import 'dart:convert';
import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'apple_kakao_naver_login.dart';
import 'apple_user_info_page.dart';
import 'login.dart';
import 'login_platform.dart';

// 전역
// secure storage
const FlutterSecureStorage storage = FlutterSecureStorage();

// Token refresh : /auth/reissue - 재발급 후에 로그아웃 처리.
Future<void> reissue(BuildContext context) async {
  final refreshToken = await storage.read(key: 'refreshToken');
  if (refreshToken == null) {
    logger.d("refreshToken is null. Redirecting to login.");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    return;
  }
  final url = Uri.parse('$serverUrl/auth/reissue');
  final headers = {'Content-Type': 'application/json'};
  final data = {
    "refreshToken": refreshToken,
  };

  final body = jsonEncode(data);

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      logger.d("reissue");

      // FlutterSecureStorage에 있는 token 삭제
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');

      Map<String, dynamic> jsonData = json.decode(response.body);
      Map<String, dynamic> token = jsonData['data'];

      // token 재작성
      await storage.write(key: 'accessToken', value: token['accessToken']);
      await storage.write(key: 'refreshToken', value: token['refreshToken']);
    } else if (response.statusCode == 401) {
      final loginViewModel = LoginViewModel(AppleKakaoNaverLogin());
      bool isLogouted = false;

      String? loginPlatform = await storage.read(key: 'loginPlatform');
      logger.d("reissue : loginPlatform - ${loginPlatform}");

      isLogouted = await loginViewModel.logout(loginPlatform);
      if (isLogouted) {
        // FlutterSecureStorage에 있는 token 삭제
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'refreshToken');
        await storage.delete(key: 'loginPlatform');
        logger.d("Unauthorized refresh. Redirecting to login.");

        if (context.mounted) {
          // 로그인 페이지로 전환
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false, // 모든 이전 페이지 제거
          );
        }
      }
    } else {
      // 실패
      logger.d("Fail to load $data. status code : ${response.statusCode}");
    }
  } catch (e) {
    logger.d("error : $e");
  }
}

class LoginViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  bool isLogouted = false;
  // 네이버, 카카오 토큰
  String? socialToken;
  // 애플 토큰
  String? identityToken;
  String? authorizationCode;

  late String accessToken;
  late String refreshToken;

  LoginPlatform loginPlatform = LoginPlatform.none;

  LoginViewModel(this._socialLogin);

  Future<bool> kakaoLogin(BuildContext context) async {
    socialToken = await _socialLogin.isKakaoLogin();
    if (socialToken != null) {
      // 카카오 로그인이 성공함
      loginPlatform = LoginPlatform.kakao;
      isLogined = (await tokenAPI(context))!;
      return isLogined;
    } else {
      logger.d("kakao login fail");
      isLogined = false;
      return isLogined;
    }
  }

  Future<bool> naverLogin(BuildContext context) async {
    socialToken = await _socialLogin.isNaverLogin();
    if (socialToken != null) {
      // 네이버 로그인 성공함
      loginPlatform = LoginPlatform.naver;
      isLogined = (await tokenAPI(context))!;
      return isLogined;
    } else {
      logger.d("naver login fail");
      isLogined = false;
      return isLogined;
    }
  }

  Future<bool> appleLogin(BuildContext context) async {
    final appleLoginToken = await _socialLogin.isAppleLogin();
    if (appleLoginToken != null) {
      // 애플 로그인 성공함
      loginPlatform = LoginPlatform.apple;
      identityToken = appleLoginToken["identityToken"];
      authorizationCode = appleLoginToken["authorizationCode"];

      isLogined = (await tokenAPI(context))!;
      return isLogined;
    } else {
      isLogined = false;
      return isLogined;
    }
  }

  Future<bool> logout(String? loginPlatformString) async {
    LoginPlatform loginPlatform = LoginPlatformExtension.fromString(
        loginPlatformString); // String -> enum
    isLogouted = await _socialLogin.isLogout(loginPlatform);
    if (isLogouted) {
      // 로그아웃 성공
      loginPlatform = LoginPlatform.none;
      isLogined = false;
      return isLogouted;
    }
    return false;
  }

  Future<bool?> tokenAPI(BuildContext context) async {
    logger.d("loginPlatform : $loginPlatform");
    Map<String, String> data;

    if (loginPlatform.name == "apple"){
      data = {
        "identityToken" : identityToken ?? "",
        "authorizationCode" : authorizationCode ?? "",
      };
    } else {
      data = {
        "token": socialToken ?? "",
      };
    }

    final url = Uri.parse('$serverUrl/auth/${loginPlatform.name}');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        Map<String, dynamic> token = jsonData['data'];

        accessToken = token['accessToken'];
        refreshToken = token['refreshToken'];

        return true;
      } else if (response.statusCode == 401) {
        logger.d("apple user sign up.");

        Map<String, dynamic> jsonData = json.decode(response.body);
        Map<String, dynamic> token = jsonData['data'];

        await storage.write(key: 'socialId', value: token['socialId']);
        await storage.write(key: 'email', value: token['email']);
        Map<String, String> allValues = await storage.readAll();

        logger.d("apple login 401 $allValues");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AppleUserInfoPage()),
        );
      } else if (response.statusCode == 409) {
        logger.d("status code : ${response.statusCode} / 사용자 이메일이 중복됩니다.");

        return false;
      } else {
        // 실패
        logger.d("Fail to load $data. status code : ${response.statusCode}");
        // 실패
        throw LoginViewModelException(
          "Fail to load. status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      logger.d("error : $e");
      throw LoginViewModelException("Error occurred: $e");
    }
  }

  Future<bool> appleSignUpPostAPI(BuildContext context, String nickName, String birthday, String gender) async {
    final socialId = await storage.read(key: 'socialId');
    final email = await storage.read(key: 'email');

    final data = {
      "nickname": nickName,
      "birthday": birthday,
      "gender": gender,
      "socialId": socialId,
      "email": email
    };

    final url = Uri.parse('$serverUrl/auth/apple/continue');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        Map<String, dynamic> token = jsonData['data'];

        // FlutterSecureStorage에 있는 token 삭제
        await storage.delete(key: 'socialId');
        await storage.delete(key: 'email');

        // 서버에서 발급받은 토큰
        accessToken = token['accessToken'];
        refreshToken = token['refreshToken'];

        return true;
      } else if (response.statusCode == 409) {
        logger.d("status code : ${response.statusCode}");

        return false;
      } else {
        // 실패
        logger.d("Fail to load $data. status code : ${response.statusCode}");
        // 실패
        throw LoginViewModelException(
            "Fail to load. status code: ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : $e");
      throw LoginViewModelException("Error occurred: $e");
    }
  }
}

// login 예외 클래스 정의
class LoginViewModelException implements Exception {
  final String message;
  LoginViewModelException(this.message);

  @override
  String toString() => 'LoginViewModelException: $message';
}
