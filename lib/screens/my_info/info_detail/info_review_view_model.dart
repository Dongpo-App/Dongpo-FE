import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/user_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../login/login_view_model.dart';
import 'package:http/http.dart' as http;

class InfoReviewViewModel{
  Future<List<UserReview>> userReviewGetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/api/my-page/reviews');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> userReviewJson = jsonData['data'];

        logger.d("userReview : $userReviewJson");

        return userReviewJson.map((item) => UserReview.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return userReviewGetAPI(context);
        } else {
          throw InfoReviewViewException("context.mounted is false");
        }
      } else {
        // 실패
        await Future.delayed(const Duration(milliseconds: 1200));
        Fluttertoast.showToast(
          msg: "리뷰 정보를 읽어오는 데 실패하였습니다.",
          timeInSecForIosWeb: 2,
        );
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        throw InfoReviewViewException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw InfoReviewViewException("Error occurred: $e");
    }
  }
  Future<bool> userReviewDeleteAPI(BuildContext context, int reviewId) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/api/store/review/$reviewId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        logger.d("review Delete : $reviewId");
        await Future.delayed(const Duration(milliseconds: 1200));
        Fluttertoast.showToast(
          msg: "리뷰가 삭제되었어요",
          timeInSecForIosWeb: 2,
        );
        return true;
      } else if(response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return userReviewDeleteAPI(context, reviewId);
        } else {
          throw InfoReviewViewException("context.mounted is false");
        }
      } else {
        // 실패
        await Future.delayed(const Duration(milliseconds: 1200));
        Fluttertoast.showToast(
          msg: "리뷰를 삭제하는 데 실패하였습니다.",
          timeInSecForIosWeb: 2,
        );
        throw InfoReviewViewException(
            "Fail to load. status code: ${response.statusCode} / ${utf8.decode(response.bodyBytes)}");
      }
    } catch (e) {
      logger.d("error : $e / reviewId : $reviewId");
      throw InfoReviewViewException("Error occurred: $e");
    }
  }
}

// user 예외 클래스 정의
class InfoReviewViewException implements Exception {
  final String message;
  InfoReviewViewException(this.message);

  @override
  String toString() => 'InfoReviewViewException: $message';
}
