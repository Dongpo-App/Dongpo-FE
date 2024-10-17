import 'dart:convert';
import 'package:dongpo_test/models/community_rack.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
import '../../models/recommend_store.dart';
import '../login/login_view_model.dart';

class CommunityViewModel {
  Future<List<RecommendStore>> recommendStoreGetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/rank/store');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> recommendStoreJson = jsonData['data'];

        logger.d("communityData - store : $recommendStoreJson");

        return recommendStoreJson.map((item) => RecommendStore.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return recommendStoreGetAPI(context);
        } else {
          throw CommunityRankException(
              "context.mounted is false"
          );
        }
      } else {
        // 실패
        throw CommunityRankException(
            "Fail to load. status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      logger.d("error : $e");
      throw CommunityRankException("Error occurred: $e");
    }
  }

  Future<List<CommunityRank>> storeTop10GetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/rank/store');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> storeTop10Json = jsonData['data'];

        logger.d("communityData - store : $storeTop10Json");

        return storeTop10Json.map((item) => CommunityRank.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return storeTop10GetAPI(context);
        } else {
          throw CommunityRankException(
              "context.mounted is false"
          );
        }
      } else {
        // 실패
        throw CommunityRankException(
            "Fail to load. status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      logger.d("error : $e");
      throw CommunityRankException("Error occurred: $e");
    }
  }

  Future<List<CommunityRank>> visitTop10GetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/rank/visit');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> visitTop10Json = jsonData['data'];

        logger.d("communityData - visit : $visitTop10Json");

        return visitTop10Json.map((item) => CommunityRank.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return visitTop10GetAPI(context);
        } else {
          throw CommunityRankException(
              "context.mounted is false"
          );
        }
      } else {
        // 실패
        throw CommunityRankException(
            "Fail to load. status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      logger.d("error : $e");
      throw CommunityRankException("Error occurred: $e");
    }
  }

  Future<List<CommunityRank>> reviewTop10GetAPI(BuildContext context) async {
    // secure storage token read
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/rank/review');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> reviewTop10GetAPI = jsonData['data'];

        logger.d("communityData - review : $reviewTop10GetAPI");

        return reviewTop10GetAPI.map((item) => CommunityRank.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        logger.d("status code : ${response.statusCode}");
        if (context.mounted) await reissue(context);
        if (context.mounted) {
          return reviewTop10GetAPI(context);
        } else {
          throw CommunityRankException(
              "context.mounted is false"
          );
        }
      } else {
        // 실패
        throw CommunityRankException(
            "Fail to load. status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      logger.d("error : $e");
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
