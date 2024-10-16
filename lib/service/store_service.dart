import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/pocha.dart';
import 'package:dongpo_test/models/store_detail.dart';
import 'package:dongpo_test/service/api_service.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:dongpo_test/service/interface/store_interface.dart';
import 'package:http/http.dart' as http;

class StoreApiService extends ApiServiceBase implements StoreServiceInterface {
  StoreApiService._privateConstructor();
  static final StoreApiService instance = StoreApiService._privateConstructor();

  @override
  Future<void> addReview(int id, Map<String, dynamic> request) async {
    await loadToken();

    // 이미지 S3에 업로드

    // S3로부터 받은 url List와 리뷰 데이터 전송

    final url = Uri.parse("$serverUrl/api/store/review/$id");
  }

  // MyData에 추가로 사용자 위치 정보를 포함한 dto 필요
  @override
  Future<bool> addStore(MyData storeInfo) async {
    await loadToken();

    final url = Uri.parse("$serverUrl/api/store");
    final headers = this.headers();
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
    await loadToken();

    final url = Uri.parse("$serverUrl/api/store/$id");
    final headers = this.headers();

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
    await loadToken(); // storage로부터 토큰 가져오기

    final url = Uri.parse('$serverUrl/api/store?latitude=$lat&longitude=$lng');
    Map<String, String> headers = this.headers();

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
        final reissued = await reissueToken();
        if (reissued) {
          // 재발급 성공시 다시 요청 보내기
          await loadToken();
          headers = this.headers();
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
            await resetToken();
            throw TokenExpiredException();
          }
        } else {
          // 재발급 실패시 토큰 다 삭제하고 로그인 화면으로 이동
          await resetToken();
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
    await loadToken();

    final url = Uri.parse("$serverUrl/api/store/$id");
    Map<String, String> headers = this.headers();

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
        final reissued = await reissueToken();
        if (reissued) {
          // 재발급 성공시 다시 요청 보내기
          await loadToken();
          headers = this.headers();
          final retryResponse = await http.get(url, headers: headers);
          decodedResponse = jsonDecode(retryResponse.body);
          if (retryResponse.statusCode == 200) {
            // 요청 성공
            Map<String, dynamic> data = decodedResponse['data'];
            logger.d(
                "code : ${response.statusCode} message : ${decodedResponse['message']}");
            return StoreSangse.fromJson(data);
          } else {
            await resetToken();
            throw TokenExpiredException();
          }
        } else {
          await resetToken();
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
