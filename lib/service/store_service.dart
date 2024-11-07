import 'dart:convert';
import 'dart:developer';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/clickedMarkerInfo.dart';
import 'package:dongpo_test/models/store_marker.dart';
import 'package:dongpo_test/models/request/add_review_request.dart';
import 'package:dongpo_test/models/request/add_store_request.dart';
import 'package:dongpo_test/models/response/api_response.dart';
import 'package:dongpo_test/models/store_detail.dart';
import 'package:dongpo_test/service/base_api_service.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:dongpo_test/service/interface/store_interface.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StoreApiService extends ApiService implements StoreServiceInterface {
  StoreApiService._privateConstructor();
  static final StoreApiService instance = StoreApiService._privateConstructor();

  @override
  Future<ApiResponse> addReview({
    required int id,
    required String reviewText,
    required List<XFile> images,
    required int rating,
  }) async {
    List<String>? imageUrls;
    await loadToken();

    // 이미지 S3에 업로드
    if (images.isNotEmpty) {
      imageUrls = await uploadImages(images);
    }
    // S3로부터 받은 url List와 리뷰 데이터 전송
    final url = Uri.parse("$serverUrl/api/store/review/$id");
    Map<String, String> headers = this.headers(true);
    final requestbody = jsonEncode(AddReviewRequest(
      reviewStar: rating,
      text: reviewText,
      reviewPics: imageUrls,
    ).toJson());

    final response = await http.post(url, headers: headers, body: requestbody);
    Map<String, dynamic> decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    try {
      if (response.statusCode == 200) {
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        return ApiResponse(
          statusCode: response.statusCode,
          message: decodedResponse['message'],
        );
      } else if (response.statusCode == 401) {
        logger.w(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        // 토큰 재발급
        final reissued = await reissueToken();
        if (reissued) {
          // 재발급 성공시 다시 요청
          headers = this.headers(true);
          final retryResponse =
              await http.post(url, headers: headers, body: requestbody);
          decodedResponse = jsonDecode(utf8.decode(retryResponse.bodyBytes));
          if (retryResponse.statusCode == 200) {
            // 요청 성공
            logger.d("리뷰 등록 성공");
            logger.d(
                "code : ${response.statusCode} message : ${decodedResponse['message']}");
            return ApiResponse(
              statusCode: response.statusCode,
              message: decodedResponse['message'],
            );
          } else {
            await resetToken();
            throw TokenExpiredException();
          }
        } else {
          await resetToken();
          throw TokenExpiredException();
        }
      } else {
        // 200, 401 이외
        return ApiResponse(
          statusCode: response.statusCode,
          message: decodedResponse['message'],
        );
      }
    } catch (e) {
      logger.e("code : ${response.statusCode} Error occured on addReview $e");
      rethrow;
    }
  }

  // StoreMarker에 추가로 사용자 위치 정보를 포함한 dto 필요
  @override
  Future<ApiResponse> addStore(AddStoreRequest storeInfo) async {
    await loadToken();

    final url = Uri.parse("$serverUrl/api/store");
    Map<String, String> headers = this.headers(true);
    final body = jsonEncode(storeInfo.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);
      Map<String, dynamic> decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        logger.d("점포 등록 성공");
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        return ApiResponse(
          statusCode: response.statusCode,
          message: decodedResponse['message'],
        );
      } else if (response.statusCode == 401) {
        logger.d("토큰 만료");
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        // 토큰 재발급
        final reissued = await reissueToken();
        if (reissued) {
          // 재발급 성공시 다시 요청
          await loadToken();
          headers = this.headers(true);
          final retryResponse =
              await http.post(url, headers: headers, body: body);
          decodedResponse = jsonDecode(utf8.decode(retryResponse.bodyBytes));
          if (retryResponse.statusCode == 200) {
            // 요청 성공
            logger.d("점포 등록 성공");
            logger.d(
                "code : ${response.statusCode} message : ${decodedResponse['message']}");
            return ApiResponse(
              statusCode: retryResponse.statusCode,
              message: decodedResponse['message'],
            );
          } else {
            // 재발급된 토큰을 가지고도 실패시
            await resetToken();
            throw TokenExpiredException();
          }
        } else {
          // 토큰 재발급 실패시
          await resetToken();
          throw TokenExpiredException();
        }
      } else {
        logger
            .d("점포 등록 실패 code : ${response.statusCode} body: $decodedResponse");
        return ApiResponse(
          statusCode: response.statusCode,
          message: decodedResponse['message'],
        );
      }
    } catch (e) {
      logger.e("HTTP Error on add store : $e");
      // 임시
      rethrow;
    }
  }

  @override
  Future<ApiResponse> deleteStore(int id) async {
    await loadToken();

    final url = Uri.parse("$serverUrl/api/store/$id");
    Map<String, String> headers = this.headers(true);

    final response = await http.delete(url, headers: headers);
    Map<String, dynamic> decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    try {
      if (response.statusCode == 200) {
        logger.d("code : ${response.statusCode} message : 점포 삭제 성공");
        return ApiResponse(
          statusCode: response.statusCode,
          message: decodedResponse['message'],
        );
      } else if (response.statusCode == 401) {
        logger.w("code : ${response.statusCode} message : 토큰 만료");
        final reissued = await reissueToken();
        if (reissued) {
          // 토큰 재발급 성공
          await loadToken();
          headers = this.headers(true);
          final retryResponse = await http.delete(url, headers: headers);
          if (retryResponse.statusCode == 200) {
            // 요청 성공
            logger.d("code : ${response.statusCode} message : 점포 삭제 성공");
            return ApiResponse(
              statusCode: retryResponse.statusCode,
              message: decodedResponse['message'],
            );
          } else {
            // 요청 최종 실패
            return ApiResponse(
              statusCode: response.statusCode,
              message: decodedResponse['message'],
            );
          }
        } else {
          // 토큰 재발급 실패
          await resetToken();
          throw TokenExpiredException();
        }
      } else {
        logger.w("code : ${response.statusCode} message : 점포 삭제 실패");
        throw Exception(
            "code : ${response.statusCode} message : HTTP ERROR! body : ${response.body}");
      }
    } catch (e) {
      if (e is! TokenExpiredException) {
        logger.e("code : ${response.statusCode} Error occured on addReview $e");
        throw Exception("Error occurred: $e");
      } else {
        // TokenExpiredException일 경우 다시 throw
        rethrow;
      }
    }
  }

  @override
  Future<ApiResponse<List<StoreMarker>>> getStoreByCurrentLocation(
      double lat, double lng) async {
    await loadToken(); // storage로부터 토큰 가져오기

    final url = Uri.parse('$serverUrl/api/store?latitude=$lat&longitude=$lng');
    Map<String, String> headers = this.headers(true);

    try {
      final response = await http.get(url, headers: headers);
      Map<String, dynamic> decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        // 요청 성공
        //List dataList = decodedResponse['data'];
        logger.d("code : ${response.statusCode} body: $decodedResponse");
        return ApiResponse<List<StoreMarker>>.fromJson(
          response.statusCode,
          decodedResponse,
          (data) {
            return (data as List<dynamic>)
                .map((item) => StoreMarker.fromJson(item))
                .toList();
          },
        );
      } else if (response.statusCode == 401) {
        // 토큰 만료
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        // 리프레쉬 토큰 재발급
        final reissued = await reissueToken();
        if (reissued) {
          // 재발급 성공시 다시 요청 보내기
          await loadToken();
          headers = this.headers(true);
          final retryResponse = await http.get(url, headers: headers);
          decodedResponse = jsonDecode(utf8.decode(retryResponse.bodyBytes));
          if (retryResponse.statusCode == 200) {
            // 요청 성공
            //List<Map<String, dynamic>> dataList = decodedResponse['data'];
            logger
                .d("code : ${retryResponse.statusCode} body: $decodedResponse");
            return ApiResponse.fromJson(
                retryResponse.statusCode,
                decodedResponse,
                (data) => (data as List)
                    .map((item) => StoreMarker.fromJson(item))
                    .toList());
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
        throw Exception(
            "code : ${response.statusCode} message : HTTP ERROR! body : ${response.body}");
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
  Future<ApiResponse<StoreSangse>> getStoreDetail(int id) async {
    await loadToken();

    final url = Uri.parse("$serverUrl/api/store/$id");
    Map<String, String> headers = this.headers(true);

    try {
      final response = await http.get(url, headers: headers);
      Map<String, dynamic> decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        // 요청 성공
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        return ApiResponse.fromJson(response.statusCode, decodedResponse,
            (data) => StoreSangse.fromJson(data));
      } else if (response.statusCode == 401) {
        // 토큰 만료
        logger.d(
            "code : ${response.statusCode} message : ${decodedResponse['message']}");
        // 리프레쉬 토큰 재발급
        final reissued = await reissueToken();
        if (reissued) {
          // 재발급 성공시 다시 요청 보내기
          await loadToken();
          headers = this.headers(true);
          final retryResponse = await http.get(url, headers: headers);
          decodedResponse = jsonDecode(utf8.decode(retryResponse.bodyBytes));
          if (retryResponse.statusCode == 200) {
            // 요청 성공
            Map<String, dynamic> data = decodedResponse['data'];
            logger.d(
                "code : ${response.statusCode} message : ${decodedResponse['message']}");
            return ApiResponse.fromJson(retryResponse.statusCode,
                decodedResponse, (data) => StoreSangse.fromJson(data));
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
  Future<ApiResponse<MarkerInfo>> getStoreSummary(int id) async {
    await loadToken();
    final url = Uri.parse('$serverUrl/api/store/$id/summary');

    Map<String, String> headers = this.headers(true);

    try {
      final response = await http.get(url, headers: headers);
      Map<String, dynamic> decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        logger.d("code: ${response.statusCode} body: $decodedResponse");
        return ApiResponse.fromJson(response.statusCode, decodedResponse,
            (data) => MarkerInfo.fromJson(data));
      } else if (response.statusCode == 401) {
        logger.d("code: ${response.statusCode} body: $decodedResponse");
        final reissued = await reissueToken();
        if (reissued) {
          await loadToken();
          headers = this.headers(true);
          final retryResponse = await http.get(url, headers: headers);
          decodedResponse = jsonDecode(utf8.decode(retryResponse.bodyBytes));

          if (retryResponse.statusCode == 200) {
            // 요청 성공
            Map<String, dynamic> data = decodedResponse['data'];
            logger.d(
                "code: ${response.statusCode} message: ${decodedResponse['message']}");
            return ApiResponse.fromJson(retryResponse.statusCode,
                decodedResponse, (data) => MarkerInfo.fromJson(data));
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
            "code: ${response.statusCode} message: ${decodedResponse['data']}");
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
  Future<ApiResponse> updateStore(int id, StoreMarker update) {
    // TODO: implement updateStore
    throw UnimplementedError();
  }
}
