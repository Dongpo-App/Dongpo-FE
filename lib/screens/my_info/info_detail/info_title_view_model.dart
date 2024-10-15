import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../models/info_user_title.dart';
import '../../login/login_view_model.dart';

class InfoTitleViewModel{
  Future<List<InfoUserTitle>> infoUserTitleGetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/api/my-page/titles');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> infoUserTitleJson = jsonData['data'];

        logger.d("infoUserTitleJson : $infoUserTitleJson");

        return infoUserTitleJson.map((item) => InfoUserTitle.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return infoUserTitleGetAPI(context);
        } else {
          throw InfoTitleViewModelException("context.mounted is false");
        }
      } else {
        // 실패
        throw InfoTitleViewModelException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw InfoTitleViewModelException("Error occurred: $e");
    }
  }
}

// user 예외 클래스 정의
class InfoTitleViewModelException implements Exception {
  final String message;
  InfoTitleViewModelException(this.message);

  @override
  String toString() => 'InfoTitleViewModelException: $message';
}
