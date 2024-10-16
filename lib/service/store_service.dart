import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/pocha.dart';
import 'package:dongpo_test/models/store_detail.dart';
import 'package:dongpo_test/screens/main/main_03/05_review.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:dongpo_test/service/interface/store_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class StoreApiService extends StoreServiceInterface {
  final storage = const FlutterSecureStorage();
  final serverUrl = "https://ysw123.xyz";
  String? _accessToken;
  String? _refreshToken;

  StoreApiService._privateConstructor();
  static final StoreApiService instance = StoreApiService._privateConstructor();

  // 토큰 저장소에서 불러오기
  Future<void> _loadToken() async {
    _accessToken = await storage.read(key: 'accessToken');
    _refreshToken = await storage.read(key: 'refreshToken');
  }

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
  }

  // 토큰 재발급
  Future<bool> _reissueToken() async {
    await _loadToken();
    if (_refreshToken == null) {
      throw TokenExpiredException();
    }

    final url = Uri.parse("$serverUrl/auth/reissue");
    final headers = {'Content-Type': 'application/json'};
    final body = {"refreshToken": _refreshToken};

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedData = jsonDecode(response.body);
        Map<String, String> token = decodedData['data'];

        await storage.write(key: 'accessToken', value: token['accessToken']);
        await storage.write(key: 'refreshToken', value: token['refreshToken']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e("Error during reissue token : $e");
      throw Exception("Token reissue failed");
    }
  }

  Future<void> _resetToken() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'loginPlatform');
  }

  @override
  Future<void> addReview(int id, Map<String, dynamic> request) {
    throw UnimplementedError();
  }

  // MyData에 추가로 사용자 위치 정보를 포함한 dto 필요
  @override
  Future<bool> addStore(MyData storeInfo) async {
    await _loadToken();

    final url = Uri.parse("$serverUrl/api/store");
    final headers = _headers();
    final body = jsonEncode(storeInfo.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        logger.d("점포 등록 성공 code : ${response.statusCode}");
        return true;
      } else {
        logger.d("점포 등록 실패 code : ${response.statusCode}");
        return false;
      }
    } catch (e) {
      logger.e("HTTP Error on add store : $e");
      return false;
    }
  }

  @override
  Future<void> deleteStore(int id) async {
    await _loadToken();

    final url = Uri.parse("$serverUrl/api/store/$id");
    final headers = _headers();

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        logger.d("code : ${response.statusCode} 점포 삭제 성공");
      } else {
        logger.w("code : ${response.statusCode} 점포 삭제 실패");
      }
    } catch (e) {
      logger.e("HTTP Error on delete store : $e");
    }
  }

  @override
  Future<List<MyData>> getStoreByCurrentLocation(double lat, double lng) async {
    await _loadToken(); // storage로부터 토큰 가져오기

    final url = Uri.parse('$serverUrl/api/store?latitude=$lat&longitude=$lng');
    Map<String, String> headers = _headers();

    try {
      final response = await http.get(url, headers: headers);
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 요청 성공
        List<Map<String, dynamic>> dataList = decodedResponse['data'];
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']} length : ${dataList.length}");
        return dataList.map((data) => MyData.fromJson(data)).toList();
      } else if (response.statusCode == 401) {
        // 토큰 만료
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        // 리프레쉬 토큰 재발급
        final reissued = await _reissueToken();
        if (reissued) {
          // 재발급 성공시 다시 요청 보내기
          await _loadToken();
          headers = _headers();
          final retryResponse = await http.get(url, headers: headers);
          decodedResponse = jsonDecode(retryResponse.body);
          if (retryResponse.statusCode == 200) {
            // 요청 성공
            List<Map<String, dynamic>> dataList = decodedResponse['data'];
            logger.d(
                "code : ${retryResponse.statusCode} message : ${decodedResponse['message']} length : ${dataList.length}");
            return dataList.map((data) => MyData.fromJson(data)).toList();
          } else {
            // 그럼에도 실패시
            await _resetToken();
            throw TokenExpiredException();
          }
        } else {
          // 재발급 실패시 토큰 다 삭제하고 로그인 화면으로 이동
          await _resetToken();
          throw TokenExpiredException();
          // if(e is TokenExpiredException) 로그인 페이지 이동
        }
      } else {
        logger.e(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        // 유저에게 에러 메시지 줘야함
        // 임시
        throw Exception("HTTP ERROR! body : ${response.body}");
      }
    } catch (e) {
      if (e is! TokenExpiredException) {
        logger.e("HTTP Error on get store by current location: $e");
        throw Exception("Error occurred: $e");
      } else {
        // TokenExpiredException일 경우 다시 throw
        rethrow;
      }
    }
  }

  @override
  Future<StoreSangse> getStoreDetail(int id) async {
    await _loadToken();

    final url = Uri.parse("$serverUrl/api/store/$id");
    Map<String, String> headers = _headers();

    try {
      final response = await http.get(url, headers: headers);
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 요청 성공
        Map<String, dynamic> data = decodedResponse['data'];
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        return StoreSangse.fromJson(data);
      } else if (response.statusCode == 401) {
        // 토큰 만료
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        // 리프레쉬 토큰 재발급
        final reissued = await _reissueToken();
        if (reissued) {
          // 재발급 성공시 다시 요청 보내기
          await _loadToken();
          headers = _headers();
          final retryResponse = await http.get(url, headers: headers);
          decodedResponse = jsonDecode(retryResponse.body);
          if (retryResponse.statusCode == 200) {
            // 요청 성공
            Map<String, dynamic> data = decodedResponse['data'];
            logger.d(
                "code : ${response.statusCode} message : ${decodedResponse['message']}");
            return StoreSangse.fromJson(data);
          } else {
            await _resetToken();
            throw TokenExpiredException();
          }
        } else {
          await _resetToken();
          throw TokenExpiredException();
        }
      } else {
        logger.e(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        // 유저에게 에러 메시지 줘야함
        // 임시
        throw Exception("HTTP ERROR! body : ${response.body}");
      }
    } catch (e) {
      if (e is! TokenExpiredException) {
        logger.e("HTTP Error on get store detail: $e");
        throw Exception("Error occurred: $e");
      } else {
        // TokenExpiredException일 경우 다시 throw
        rethrow;
      }
    }
  }

  @override
  Future<MyData> getStoreSummary(int id) {
    // TODO: implement getStoreSummary
    throw UnimplementedError();
  }

  @override
  Future<void> updateStore(int id, MyData update) {
    // TODO: implement updateStore
    throw UnimplementedError();
  }
}
