import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/user_review.dart';
import 'package:flutter/cupertino.dart';
import '../../login/login_view_model.dart';
import 'package:http/http.dart' as http;

class InfoReviewViewModel{
  Future<List<UserReview>> userReviewGetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse(serverUrl + '/api/my-page/reviews');
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
        await reissue(context);
        return userReviewGetAPI(context);
      } else {
        // 실패
        throw InfoReviewViewException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
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
