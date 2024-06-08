import 'dart:convert';
import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
import 'login_platform.dart';

class LoginViewModel with ChangeNotifier{
  final SocialLogin _socialLogin;
  bool isLogined = false;
  bool isLogouted = false;
  String? socialToken;
  late String accessToken;
  late String refreshToken;

  LoginPlatform loginPlatform = LoginPlatform.none;

  LoginViewModel(this._socialLogin);

  Future kakaoLogin() async {
    socialToken = await _socialLogin.isKakaoLogin();
    if (socialToken != null) {
      // 카카오 로그인이 성공함
      loginPlatform = LoginPlatform.kakao;
      tokenAPI();
      isLogined = true;
    } else {
      logger.d("kakao login fail");
    }
  }

  Future naverLogin() async {
    socialToken = await _socialLogin.isNaverLogin();
    if(socialToken != null) {
      // 네이버 로그인 성공함
      loginPlatform = LoginPlatform.naver;
      tokenAPI();
      isLogined = true;
    } else {
      logger.d("naver login fail");
    }
  }

  Future logout() async {
    isLogouted = await _socialLogin.isLogout(loginPlatform);
    if(isLogouted){
      // 로그아웃 성공
      loginPlatform = LoginPlatform.none;
      isLogined = false;
    }
  }

  Future<void> tokenAPI() async {
    final data = {
      "token": socialToken,
    };
    final url = Uri.parse('https://1417mhz.xyz/auth/${loginPlatform.name}');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        Map<String, dynamic> token = jsonData['data'];

        accessToken = token['accessToken'];
        refreshToken = token['refreshToken'];

      } else {
        // 실패
        logger.d("Fail to load ${data}. status code : ${response.statusCode}");
      }
    } catch (e) {
      logger.d("error : ${e}");
    }
  }
}