import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../login/login_view_model.dart';

class BookmarkViewModel{
  Future<List<UserBookmark>> userBookmarkGetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse(serverUrl + '/api/my-page/bookmarks');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> userBookmarkJson = jsonData['data'];

        logger.d("userBookmark : $userBookmarkJson");

        return userBookmarkJson.map((item) => UserBookmark.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        await reissue(context);
        return userBookmarkGetAPI(context);
      } else {
        // 실패
        throw UserBookmarkException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw UserBookmarkException("Error occurred: $e");
    }
  }

  Future<bool> userBookmarkDeleteAPI(BuildContext context, int bookmarkId) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse(serverUrl + '/api/bookmark/${bookmarkId}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else if(response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        await reissue(context);
        return userBookmarkDeleteAPI(context, bookmarkId);
      } else {
        // 실패
        throw UserBookmarkException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw UserBookmarkException("Error occurred: $e");
    }
  }
}

// user 예외 클래스 정의
class UserBookmarkException implements Exception {
  final String message;
  UserBookmarkException(this.message);

  @override
  String toString() => 'UserBookmarkException: $message';
}
