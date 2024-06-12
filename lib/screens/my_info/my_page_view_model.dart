import 'dart:convert';

import 'package:dongpo_test/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../main.dart';

class MyPageViewModel{
  // test
  // secure storage
  static final storage = FlutterSecureStorage();

  Future<UserProfile?> userProfileGetAPI() async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('https://1417mhz.xyz/api/my-page');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final userProfileJson = jsonData['data'];
        logger.d("jsonData : ${userProfileJson}");
        // 각 필드의 타입을 출력
        userProfileJson.forEach((key, value) {
          print('$key: ${value.runtimeType}');
        });
        return UserProfile.fromJson(userProfileJson);
      } else {
        // 실패
        logger.d("Fail to load. status code : ${response.statusCode}");
        return null;
      }
    } catch (e) {
      logger.d("error : ${e}");
      return null;
    }
  }
}