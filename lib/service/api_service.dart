import 'dart:convert';
import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/* 
api 요청 관련 try catch로 잡아야하는 오류 (추후 작업)
1. 네트워크 관련
연결 실패: 서버에 연결할 수 없는 경우(예: 인터넷 연결 끊김, 서버 다운 등).
타임아웃: 요청이 지정된 시간 내에 완료되지 않는 경우.
DNS 오류: 도메인 이름을 해석할 수 없는 경우.
2. http 요청이 잘못됨 
잘못된 URL: URL이 잘못되어 요청이 실패하는 경우.
잘못된 요청 형식: HTTP 메서드나 헤더가 잘못된 경우(예: 잘못된 Content-Type).
SSL/TLS 오류: HTTPS를 사용할 때 인증서 문제로 인해 발생하는 오류.
*/

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

  // json 헤더 생성
  Map<String, String> headers(bool withAccessToken) {
    return withAccessToken // true -> accessToken 추가
        ? {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_accessToken',
          }
        : {
            'Content-Type': 'application/json',
          };
  }

  void errorLog({required int statusCode, required String message}) {
    logger.e("code : $statusCode message : $message");
  }

  // 토큰 재발급
  Future<bool> reissueToken() async {
    await loadToken();
    if (_refreshToken == null) {
      throw TokenExpiredException();
    }

    final url = Uri.parse("$serverUrl/auth/reissue");
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"refreshToken": _refreshToken});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedData =
            jsonDecode(utf8.decode(response.bodyBytes));
        Map<String, dynamic> token = decodedData['data'];

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
      final jsonData = jsonDecode(utf8.decode(responseData.bodyBytes));

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
