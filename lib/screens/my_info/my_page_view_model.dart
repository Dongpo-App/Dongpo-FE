import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dongpo_test/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../main.dart';

class MyPageViewModel {
  // secure storage
  static final storage = FlutterSecureStorage();

  Future<UserProfile> userProfileGetAPI() async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('https://ysw123.xyz/api/my-page');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      logger.d("message : ${response.body}");
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final userProfileJson = jsonData['data'];

        logger.d("userData : ${userProfileJson}");

        return UserProfile.fromJson(userProfileJson);
      } else {
        // 실패
        throw UserProfileException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : ${e}");
      throw UserProfileException("Error occurred: $e");
    }
  }

  Future<bool> userProfileUpdateAPI(dynamic? pic, String nickname, String newMainTitle) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    logger.d("userProfileUpdate : ${pic}, ${nickname}");

    // 사용자 프로필 사진 업로드 API
    String? userPicURL;
    if (pic != null) {
      userPicURL = await userPicUploadAPI(pic);
    } else {
      userPicURL = null;
    }

    final data = {
      "nickname": nickname,
      "profilePic": userPicURL,
      "newMainTitle" : newMainTitle,
    };
    final url = Uri.parse('https://ysw123.xyz/api/my-page');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = jsonEncode(data);

    try {
      final response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        // 실패
        logger.d("Fail to load ${data}. status code : ${response.statusCode}");
        return false;
      }
    } catch (e) {
      logger.d("error : ${e}");
      return false;
    }
  }

  Future<String?> userPicUploadAPI(dynamic pic) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    var dio = new Dio();

    var formData =
        FormData.fromMap({'image': await MultipartFile.fromFile(pic)});

    final url = 'https://ysw123.xyz/api/file-upload';

    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.headers = {'Authorization': 'Bearer $accessToken'};

      final response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;

        List<dynamic> dataList = jsonData['data'];
        String imageUrl = dataList[0]['imageUrl'];
        
        return imageUrl;
      } else {
        // 실패
        logger.d(
            "Fail to upload ${formData}. status code : ${response.statusCode}");

        return null;
      }
    } catch (e) {
      logger.d("error : ${e}");
      return null;
    }
  }
}

// user 예외 클래스 정의
class UserProfileException implements Exception {
  final String message;
  UserProfileException(this.message);

  @override
  String toString() => 'UserProfileException: $message';
}
