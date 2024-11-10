import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../login/login_view_model.dart';

class BookmarkViewModel{
  Future<List<UserBookmark>> userBookmarkGetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/api/my-page/bookmarks');
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
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return userBookmarkGetAPI(context);
        } else {
          throw UserBookmarkException("context.mounted is false");
        }
      } else if (response.statusCode == 404) {
        await Future.delayed(const Duration(milliseconds: 1200));
        Fluttertoast.showToast(
          msg: "점포 정보를 읽어오는 데 실패 했어요",
          timeInSecForIosWeb: 2,
        );
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        throw UserBookmarkException(
            "Fail to load. status code: ${response.statusCode}");
      } else {
        // 실패
        await Future.delayed(const Duration(milliseconds: 1200));
        Fluttertoast.showToast(
          msg: "북마크 정보를 읽어오는 데 실패 했어요",
          timeInSecForIosWeb: 2,
        );
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        throw UserBookmarkException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw UserBookmarkException("Error occurred: $e");
    }
  }

  Future<bool> userBookmarkDeleteAPI(BuildContext context, int storeId) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/api/bookmark/${storeId}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        logger.d("bookmark Delete : $storeId");
        await Future.delayed(const Duration(milliseconds: 100));
        Fluttertoast.showToast(
          msg: "북마크가 삭제되었어요",
          timeInSecForIosWeb: 2,
        );
        return true;
      } else if(response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return userBookmarkDeleteAPI(context, storeId);
        } else {
          throw UserBookmarkException("context.mounted is false");
        }
      } else {
        // 실패
        throw UserBookmarkException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e / bookmarkId : ${storeId}");
      await Future.delayed(const Duration(milliseconds: 100));
      Fluttertoast.showToast(
        msg: "북마크 삭제에 실패 했어요",
        timeInSecForIosWeb: 2,
      );
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
