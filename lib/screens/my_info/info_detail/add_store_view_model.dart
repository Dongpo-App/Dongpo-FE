import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/user_add_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../login/login_view_model.dart';

class AddStoreViewModel{
  Future<List<UserAddStore>> userAddStoreGetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse(serverUrl + '/api/my-page/stores');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> userAddStoreJson = jsonData['data'];

        logger.d("userAddStoreJson : $userAddStoreJson");

        return userAddStoreJson.map((item) => UserAddStore.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        await reissue(context);
        return userAddStoreGetAPI(context);
      } else {
        // 실패
        throw AddStoreException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw AddStoreException("Error occurred: $e");
    }
  }
}

// user 예외 클래스 정의
class AddStoreException implements Exception {
  final String message;
  AddStoreException(this.message);

  @override
  String toString() => 'AddStoreException: $message';
}
