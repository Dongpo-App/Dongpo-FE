import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dongpo_test/models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
import '../login/login_view_model.dart';

class MyPageViewModel {
  Future<UserProfile> userProfileGetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/api/my-page');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final userProfileJson = jsonData['data'];
        logger.d("userData : $userProfileJson");

        return UserProfile.fromJson(userProfileJson);
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return userProfileGetAPI(context);
        } else {
          throw UserProfileException(
              "context.mounted is false");
        }
      } else {
        logger.d("Fail to load. status code : ${response.statusCode}");
        // 실패
        throw UserProfileException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw UserProfileException("Error occurred: $e");
    }
  }

  Future<bool> userProfileUpdateAPI(BuildContext context, dynamic pic,
      String nickname, String newMainTitle) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    logger.d("userProfileUpdate : $pic, $nickname");

    // 사용자 프로필 사진 업로드 API
    String? userPicURL;
    if (pic != null && context.mounted) {
      userPicURL = await userPicUploadAPI(context, pic);
    } else {
      userPicURL = null;
    }

    final data = {
      "nickname": nickname,
      "profilePic": userPicURL,
      "newMainTitle": newMainTitle,
    };
    final url = Uri.parse('$serverUrl/api/my-page');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = jsonEncode(data);

    try {
      final response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return userProfileUpdateAPI(context, pic, nickname, newMainTitle);
        } else {
          throw UserProfileException(
              "context.mounted is false");
        }
      } else {
        // 실패
        logger.d("Fail to load $data. status code : ${response.statusCode}");
        throw UserProfileException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw UserProfileException("Error occurred: $e");
    }
  }

  Future<String?> userPicUploadAPI(BuildContext context, dynamic pic) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    var dio = Dio();

    var formData =
        FormData.fromMap({'image': await MultipartFile.fromFile(pic)});

    const url = '$serverUrl/api/file-upload';

    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.headers = {'Authorization': 'Bearer $accessToken'};

      final response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;

        List<dynamic> dataList = jsonData['data'];
        String imageUrl = dataList[0]['imageUrl'];

        return imageUrl;
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return userPicUploadAPI(context, pic);
        } else {
          throw UserProfileException(
              "context.mounted is false");
        }
      } else {
        // 실패
        logger.d(
            "Fail to upload $formData. status code : ${response.statusCode}");
        throw UserProfileException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw UserProfileException("Error occurred: $e");
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
