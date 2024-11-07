import 'dart:convert';
import 'package:dongpo_test/api_key.dart';
import 'package:dongpo_test/models/response/api_response.dart';
import 'package:dongpo_test/models/request/apple_signup_request.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/service/base_api_service.dart';
import 'package:dongpo_test/service/interface/login_interface.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginApiService extends ApiService implements LoginServiceInterface {
  LoginApiService._privateConstructor();
  static final LoginApiService instance = LoginApiService._privateConstructor();

  static String? email;

  Future<ApiResponse> _tokenSubmit({
    required String loginPlatform,
    required String accessToken,
    String? authCode,
  }) async {
    final url = Uri.parse("$serverUrl/auth/$loginPlatform");
    final headers = this.headers(false);
    final body = jsonEncode(loginPlatform == "apple"
        ? {
            "identityToken": accessToken,
            "authorizationCode": authCode,
          }
        : {
            "token": accessToken,
          });

    try {
      final response = await http.post(url, headers: headers, body: body);
      Map<String, dynamic> decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.d(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        Map<String, dynamic> data = decodedResponse['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        logger.d("loginPlatform: $loginPlatform");
        logger.d("accessToken: $accessToken");
        logger.d("refreshToken: $refreshToken");

        storage.write(key: "loginPlatform", value: loginPlatform);
        storage.write(key: 'accessToken', value: accessToken);
        storage.write(key: 'refreshToken', value: refreshToken);
        return ApiResponse(
          statusCode: response.statusCode,
          message: "success",
        );
      } else if (response.statusCode == 401) {
        // 애플 로그인시 추가 정보
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        Map<String, dynamic> data = decodedResponse['data'];
        email = data['email'];
        logger.d("userData: $data");
        return ApiResponse(
            statusCode: response.statusCode,
            message: "additional info required for signup",
            data: data);
      } else if (response.statusCode == 409) {
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        return ApiResponse(
            statusCode: response.statusCode, message: "duplicated email");
      } else {
        // 통신 실패
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        return ApiResponse(statusCode: response.statusCode, message: "error");
      }
    } catch (e) {
      logger.e("토큰 전송 실패 : $e");
      return ApiResponse(statusCode: 500, message: "error");
    }
  }

  @override
  Future<ApiResponse> appleLogin() async {
    try {
      final AuthorizationCredentialAppleID appleID =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final String? identityToken = appleID.identityToken;
      final String authCode = appleID.authorizationCode;
      logger.d("Apple login userIdentifier: ${appleID.userIdentifier}");
      logger.d("Apple login identityToken: $identityToken");
      logger.d("Apple login authorizationCode: $authCode");

      if (identityToken != null) {
        return _tokenSubmit(
          loginPlatform: "apple",
          accessToken: identityToken,
          authCode: authCode,
        );
      } else {
        logger.w("Apple login failed: no identity token");
        return ApiResponse(
          statusCode: 500,
          message: "Apple login failed: no identity token",
        );
      }
    } catch (e) {
      logger.e(e);
      return ApiResponse(
        statusCode: 500,
        message: "Apple login failed: $e",
      );
    }
  }

  @override
  Future<ApiResponse> appleSignup(AppleSignupRequest request) async {
    final url = Uri.parse("$serverUrl/auth/apple/continue");
    final headers = this.headers(false);
    final body = jsonEncode(request.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.d(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        Map<String, dynamic> data = decodedResponse['data'];

        String accessToken = data['accessToken'];
        String refreshToken = data['refreshToken'];
        logger.d("accessToken: $accessToken");
        logger.d("refreshToken: $refreshToken");

        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);
        await storage.write(key: 'loginPlatform', value: "apple");

        return ApiResponse(statusCode: response.statusCode, message: "success");
      } else if (response.statusCode == 409) {
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        return ApiResponse(
            statusCode: response.statusCode, message: "duplicated email");
      } else {
        // 통신 실패
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        return ApiResponse(statusCode: response.statusCode, message: "error");
      }
    } catch (e) {
      logger.e("애플 회원 가입 실패 : $e");
      return ApiResponse(statusCode: 500, message: "error");
    }
  }

  @override
  Future<ApiResponse> kakaoLogin() async {
    OAuthToken oauthToken;
    //카카오톡 실행 가능 여부 확인
    if (await isKakaoTalkInstalled()) {
      try {
        oauthToken = await UserApi.instance.loginWithKakaoTalk();
        logger.d(
            "kakaoTalk login accessToken: ${oauthToken.accessToken.toString()}");
      } catch (e) {
        logger.e("kakaoTalk login error: $e");
        if (e is PlatformException && e.code == "CANCELED") {
          // 로그인 취소
          return ApiResponse(
            statusCode: 400,
            message: "kakaoTalk login error: $e",
          );
        }
        // 카카오톡에 연결된 계정이 없는 경우
        try {
          oauthToken = await UserApi.instance.loginWithKakaoAccount();
          logger.d(
              "kakaoAccount login accessToken: ${oauthToken.accessToken.toString()}");
        } catch (e) {
          logger.e("kakaoAccount login error: $e");
          return ApiResponse(
            statusCode: 500,
            message: "kakaoAccount login error: $e",
          );
        }
      }
    } else {
      // 카카오톡 어플이 설치되지 않은 경우
      try {
        oauthToken = await UserApi.instance.loginWithKakaoAccount();
        logger.d(
            "kakaoAccount login accessToken: ${oauthToken.accessToken.toString()}");
      } catch (e) {
        logger.e("kakaoAccount login error: $e");
        return ApiResponse(
          statusCode: 500,
          message: "kakaoAccount login error: $e",
        );
      }
    }

    return await _tokenSubmit(
        loginPlatform: "kakao", accessToken: oauthToken.accessToken);
  }

  @override
  Future<ApiResponse> naverLogin() async {
    NaverAccessToken token;
    try {
      NaverLoginResult result = await FlutterNaverLogin.logIn();
      logger.d("naver login result: ${result.toString()}");
      token = await FlutterNaverLogin.currentAccessToken;
      logger.d("naver login accessToken: ${token.accessToken}");
    } catch (e) {
      logger.e("naver login error: $e");
      return ApiResponse(
        statusCode: 500,
        message: "naver login error: $e",
      );
    }

    return await _tokenSubmit(
        loginPlatform: "naver", accessToken: token.accessToken);
  }

  @override
  Future<ApiResponse> logout() async {
    final platform = await storage.read(key: "loginPlatform");
    bool isSocialLogoutSuccess = false;
    bool isServerLogoutSuccess = false;

    // 1. 소셜 로그아웃
    isSocialLogoutSuccess = await socialLogout(platform);
    // 2. 서버 로그아웃
    if (isSocialLogoutSuccess) {
      // 소셜 로그아웃 성공한 경우에만
      await loadToken();
      final url = Uri.parse("$serverUrl/auth/logout");
      Map<String, String> headers = this.headers(true);

      try {
        final response = await http.post(url, headers: headers);
        Map<String, dynamic> decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        if (response.statusCode == 200) {
          // 로그아웃 성공
          logger.d("code: ${response.statusCode} body: $decodedResponse");
          isServerLogoutSuccess = true;
        } else if (response.statusCode == 401) {
          // 토큰 만료
          logger.w("code: ${response.statusCode} body: $decodedResponse");
          // 토큰 재발급
          final reissued = await reissueToken();
          if (reissued) {
            // 토큰 재발급 성공시 재요청
            headers = this.headers(true);
            final retryResponse = await http.post(url, headers: headers);
            decodedResponse = jsonDecode(utf8.decode(retryResponse.bodyBytes));
            if (retryResponse.statusCode == 200) {
              // 재요청 성공
              logger.d(
                  "code: ${retryResponse.statusCode} body: $decodedResponse");
              isServerLogoutSuccess = true;
            } else {
              // 재요청 실패
              logger.e(
                  "code: ${retryResponse.statusCode} body: $decodedResponse");
              throw ServerLogoutException();
            }
          } else {
            // 토큰 재발급 실패 == 토큰 만료 -> 로그인
            throw TokenExpiredException();
          }
        } else {
          // 서버 로그아웃 실패
          logger.e("code: ${response.statusCode} body: $decodedResponse");
          throw ServerLogoutException();
        }

        // 토큰 삭제
        if (isServerLogoutSuccess) {
          await resetToken();
          return ApiResponse(
            statusCode: response.statusCode,
            message: decodedResponse['message'],
          );
        } else {
          throw ServerLogoutException();
        }
      } catch (e) {
        logger.e("server logout failed : $e");
        rethrow;
      }
    } else {
      // 소셜 로그아웃 실패
      return ApiResponse(statusCode: 500, message: "social logout failed");
    }
  }

  @override
  Future<ApiResponse> deleteAccount() async {
    final platform = await storage.read(key: "loginPlatform");
    bool isSocialDeleteSuccess = false;
    bool isServerDeleteSuccess = false;
    // 1. 소셜 연동 해제
    isSocialDeleteSuccess = await unlinkSocialAccount(platform);
    // 2. 서버에 탈퇴 요청
    if (isSocialDeleteSuccess) {
      // 소셜 탈퇴 성공한 경우에만
      await loadToken();
      final url = Uri.parse("$serverUrl/auth/leave");
      Map<String, String> headers = this.headers(true);

      try {
        final response = await http.post(url, headers: headers);
        Map<String, dynamic> decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        if (response.statusCode == 200) {
          // 탈퇴 성공
          logger.d("code: ${response.statusCode} body: $decodedResponse");
          isServerDeleteSuccess = true;
        } else if (response.statusCode == 401) {
          // 토큰 만료
          logger.w("code: ${response.statusCode} body: $decodedResponse");
          // 토큰 재발급
          final reissued = await reissueToken();
          if (reissued) {
            // 토큰 재발급 성공
            headers = this.headers(true);
            final retryResponse = await http.post(url, headers: headers);
            decodedResponse = jsonDecode(utf8.decode(retryResponse.bodyBytes));
            if (retryResponse.statusCode == 200) {
              // 재요청 성공
              logger.d(
                  "code: ${retryResponse.statusCode} body: $decodedResponse");
              isServerDeleteSuccess = true;
            } else {
              // 재요청 실패
              logger.e(
                  "code: ${retryResponse.statusCode} body: $decodedResponse");
              throw AccountDeletionFailureException();
            }
          } else {
            // 토큰 재발급 실패
            throw TokenExpiredException();
          }
        } else {
          // 서버 로그아웃 실패
          logger.e("code: ${response.statusCode} body: $decodedResponse");
        }
        // 3. 서버 로그인 성공시 토큰 삭제
        if (isServerDeleteSuccess) {
          await resetToken();
          return ApiResponse(
            statusCode: response.statusCode,
            message: decodedResponse['message'],
          );
        } else {
          throw AccountDeletionFailureException();
        }
      } catch (e) {
        logger.e("failed to leave : $e");
        rethrow;
      }
    } else {
      // 소셜 탈퇴 실패
      return ApiResponse(
          statusCode: 500, message: "failed to delete your account");
    }
  }

  Future<bool> socialLogout(String? platform) async {
    switch (platform) {
      case "kakao":
        try {
          await UserApi.instance.logout();
          logger.d("$platform logout successfully!");
          return true;
        } catch (e) {
          logger.e("$platform logout error: $e");
          return false;
        }
      case "naver":
        try {
          await FlutterNaverLogin.logOut();
          logger.d("$platform logout successfully!");
          return true;
        } catch (e) {
          logger.e("$platform logout error: $e");
          return false;
        }
      case "apple":
        logger.d("$platform logout successfully!");
        return true;
      default:
        logger.d("$platform is Unauthorized platform");
        return false;
    }
  }

  Future<bool> unlinkSocialAccount(String? platform) async {
    switch (platform) {
      case "kakao":
        try {
          await UserApi.instance.unlink();
          logger.d("$platform logout successfully!");
          return true;
        } catch (e) {
          logger.e("$platform logout error: $e");
          return false;
        }
      case "naver":
        try {
          await FlutterNaverLogin.logOut();
          logger.d("$platform logout successfully!");
          return true;
        } catch (e) {
          logger.e("$platform logout error: $e");
          return false;
        }
      case "apple":
        logger.d("$platform logout successfully!");
        return true;
      default:
        logger.d("$platform is Unauthorized platform");
        return false;
    }
  }
}
