import 'dart:convert';
import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  final storage = const FlutterSecureStorage();
  final serverUrl = "https://ysw123.xyz";
  String? _accessToken;
  String? _refreshToken;

  // 토큰 저장소에서 불러오기
  Future<void> loadToken() async {
    _accessToken = await storage.read(key: 'accessToken');
    _refreshToken = await storage.read(key: 'refreshToken');
  }

  Map<String, String> headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
  }

  // 토큰 재발급
  Future<bool> reissueToken() async {
    await loadToken();
    if (_refreshToken == null) {
      throw TokenExpiredException();
    }

    final url = Uri.parse("$serverUrl/auth/reissue");
    final headers = {'Content-Type': 'application/json'};
    final body = {"refreshToken": _refreshToken};

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedData = jsonDecode(response.body);
        Map<String, String> token = decodedData['data'];

        await storage.write(key: 'accessToken', value: token['accessToken']);
        await storage.write(key: 'refreshToken', value: token['refreshToken']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e("Error during reissue token : $e");
      throw Exception("Token reissue failed");
    }
  }

  // 토큰 삭제
  Future<void> resetToken() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'loginPlatform');
  }

  // 사진 파일 S3 업로드
  Future<List<String>> uploadImages(List<XFile> images) async {
    await loadToken();
    final url = Uri.parse("$serverUrl/api/file-upload");
    final request = http.MultipartRequest("POST", url)
      ..headers['Authorization'] = 'Bearer $_accessToken';

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath("image", image.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final jsonData = jsonDecode(responseData.body);

      // Check if the data contains a list of image URLs
      if (jsonData['data'] is List) {
        // Extract the image URLs from the response
        List<String> imageUrls = (jsonData['data'] as List)
            .map((item) => item['imageUrl'].toString())
            .toList();
        logger.d(imageUrls);
        return imageUrls;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('code : ${response.statusCode} Failed to upload images');
    }
  }
}
