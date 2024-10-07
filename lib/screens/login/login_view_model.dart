import 'dart:convert';
import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
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
      logger.d("Unauthorized refresh. Redirecting to login.");
      // FlutterSecureStorage에 있는 token 삭제
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');

      // 로그인 페이지로 전환
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
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
  String? socialToken;
  late String accessToken;
  late String refreshToken;

  LoginPlatform loginPlatform = LoginPlatform.none;

  LoginViewModel(this._socialLogin);

  Future<bool> kakaoLogin(BuildContext context) async {
    socialToken = await _socialLogin.isKakaoLogin();
    if (socialToken != null) {
      // 카카오 로그인이 성공함
      loginPlatform = LoginPlatform.kakao;
      isLogined = await tokenAPI(context);
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
      isLogined = await tokenAPI(context);
      return isLogined;
    } else {
      logger.d("naver login fail");
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

  Future<bool> tokenAPI(BuildContext context) async {
    logger.d("loginPlatform : $loginPlatform");

    final data = {
      "token": socialToken,
    };
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
        logger.d("status code : ${response.statusCode}");
        await reissue(context);
        return tokenAPI(context);
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
