import 'dart:convert';
import 'package:dongpo_test/models/community_rack.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
import '../login/login_view_model.dart';

class CommunityViewModel {
  Future<List<CommunityRank>> storeTop10GetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('https://ysw123.xyz/rank/store');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> storeTop10Json = jsonData['data'];

        logger.d("communityData - store : ${storeTop10Json}");

        return storeTop10Json.map((item) => CommunityRank.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        await reissue(context);
        return storeTop10GetAPI(context);
      } else {
        // 실패
        throw CommunityRankException(
            "Fail to load. status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      logger.d("error : ${e}");
      throw CommunityRankException("Error occurred: $e");
    }
  }

  Future<List<CommunityRank>> visitTop10GetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('https://ysw123.xyz/rank/visit');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> visitTop10Json = jsonData['data'];

        logger.d("communityData - visit : ${visitTop10Json}");

        return visitTop10Json.map((item) => CommunityRank.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        await reissue(context);
        return visitTop10GetAPI(context);
      } else {
        // 실패
        throw CommunityRankException(
            "Fail to load. status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      logger.d("error : ${e}");
      throw CommunityRankException("Error occurred: $e");
    }
  }

  Future<List<CommunityRank>> reviewTop10GetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('https://ysw123.xyz/rank/review');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> reviewTop10GetAPI = jsonData['data'];

        logger.d("communityData - review : ${reviewTop10GetAPI}");

        return reviewTop10GetAPI.map((item) => CommunityRank.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        await reissue(context);
        return reviewTop10GetAPI(context);
      } else {
        // 실패
        throw CommunityRankException(
            "Fail to load. status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      logger.d("error : ${e}");
      throw CommunityRankException("Error occurred: $e");
    }
  }
}

// rank 예외 클래스 정의
class CommunityRankException implements Exception {
  final String message;
  CommunityRankException(this.message);

  @override
  String toString() => 'CommunityRankException: $message';
}
