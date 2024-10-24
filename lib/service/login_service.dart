import 'dart:convert';
import 'package:dongpo_test/models/login_response.dart';
import 'package:dongpo_test/models/request/apple_signup_request.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/service/api_service.dart';
import 'package:dongpo_test/service/interface/login_interface.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginApiService extends ApiService implements LoginServiceInterface {
  LoginApiService._privateConstructor();
  static final LoginApiService instance = LoginApiService._privateConstructor();

  static String? email;

  Future<LoginResponse> _tokenSubmit({
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
        return LoginResponse(
            statusCode: response.statusCode, message: "success");
      } else if (response.statusCode == 401) {
        // 애플 로그인시 추가 정보
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        Map<String, dynamic> data = decodedResponse['data'];
        email = data['email'];
        logger.d("userData: $data");
        return LoginResponse(
            statusCode: response.statusCode,
            message: "additional info required for signup",
            data: data);
      } else if (response.statusCode == 409) {
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        return LoginResponse(
            statusCode: response.statusCode, message: "duplicated email");
      } else {
        // 통신 실패
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        return LoginResponse(statusCode: response.statusCode, message: "error");
      }
    } catch (e) {
      logger.e("토큰 전송 실패 : $e");
      return LoginResponse(statusCode: 500, message: "error");
    }
  }

  @override
  Future<LoginResponse> appleLogin() async {
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
        return LoginResponse(statusCode: 500);
      }
    } catch (e) {
      logger.e(e);
      return LoginResponse(statusCode: 500);
    }
  }

  @override
  Future<bool> appleLeave() {
    // TODO: implement appleLeave
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> kakaoLogin() async {
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
          return LoginResponse(statusCode: 400);
        }
        // 카카오톡에 연결된 계정이 없는 경우
        try {
          oauthToken = await UserApi.instance.loginWithKakaoAccount();
          logger.d(
              "kakaoAccount login accessToken: ${oauthToken.accessToken.toString()}");
        } catch (e) {
          logger.e("kakaoAccount login error: $e");
          return LoginResponse(statusCode: 500);
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
        return LoginResponse(statusCode: 500);
      }
    }

    return await _tokenSubmit(
        loginPlatform: "kakao", accessToken: oauthToken.accessToken);
  }

  @override
  Future<LoginResponse> naverLogin() async {
    NaverAccessToken token;
    try {
      NaverLoginResult result = await FlutterNaverLogin.logIn();
      logger.d("naver login result: ${result.toString()}");
      token = await FlutterNaverLogin.currentAccessToken;
      logger.d("naver login accessToken: ${token.accessToken}");
    } catch (e) {
      logger.e("naver login error: $e");
      return LoginResponse(statusCode: 500);
    }

    return await _tokenSubmit(
        loginPlatform: "naver", accessToken: token.accessToken);
  }

  @override
  Future<bool> logout() async {
    await loadToken();
    final platform = await storage.read(key: "loginPlatform");
    final url = Uri.parse("$serverUrl/auth/logout");
    final headers = this.headers(true);
    logger.d("header : $headers");
    try {
      final response = await http.post(url, headers: headers);
      Map<String, dynamic> decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        logger.d("code: ${response.statusCode} body: $decodedResponse");
      } else {
        logger.e("code: ${response.statusCode} body: $decodedResponse");
      }
    } catch (e) {
      logger.e(e);
      return false;
    }
    switch (platform) {
      case "kakao":
        try {
          await UserApi.instance.unlink();
          await resetToken();
          logger.d("$platform logout successfully!");
          return true;
        } catch (e) {
          logger.e("$platform logout error: $e");
          return false;
        }
      case "naver":
        try {
          await FlutterNaverLogin.logOut();
          await resetToken();
          logger.d("$platform logout successfully!");
          return true;
        } catch (e) {
          logger.e("$platform logout error: $e");
          return false;
        }
      case "apple":
        await resetToken();
        logger.d("$platform logout successfully!");
        return true;
      default:
        logger.d("$platform is Unauthorized platform");
        return true;
    }
  }

  @override
  Future<LoginResponse> appleSignup(AppleSignupRequest request) async {
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

        return LoginResponse(
            statusCode: response.statusCode, message: "success");
      } else if (response.statusCode == 409) {
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        return LoginResponse(
            statusCode: response.statusCode, message: "duplicated email");
      } else {
        // 통신 실패
        logger.w(
            "code: ${response.statusCode} body: ${decodedResponse.toString()}");
        return LoginResponse(statusCode: response.statusCode, message: "error");
      }
    } catch (e) {
      logger.e("애플 회원 가입 실패 : $e");
      return LoginResponse(statusCode: 500, message: "error");
    }
  }
}
