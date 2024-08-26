import 'dart:convert';
import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/main.dart';
import 'login_platform.dart';

class LoginViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  bool isLogouted = false;
  String? socialToken;
  late String accessToken;
  late String refreshToken;

  LoginPlatform loginPlatform = LoginPlatform.none;

  LoginViewModel(this._socialLogin);

  Future<bool> kakaoLogin() async {
    socialToken = await _socialLogin.isKakaoLogin();
    if (socialToken != null) {
      // 카카오 로그인이 성공함
      loginPlatform = LoginPlatform.kakao;
      isLogined = await tokenAPI();
      return isLogined;
    } else {
      logger.d("kakao login fail");
      isLogined = false;
      return isLogined;
    }
  }

  Future<bool> naverLogin() async {
    logger.d('naverLogin() 진입했다');
    socialToken = await _socialLogin.isNaverLogin();
    logger.d('_socialLogin.isNaverLogin() 성공했다.');
    if (socialToken != null) {
      // 네이버 로그인 성공함
      loginPlatform = LoginPlatform.naver;
      isLogined = await tokenAPI();
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

  Future<bool> tokenAPI() async {
    logger.d("loginPlatform : ${loginPlatform}");

    final data = {
      "token": socialToken,
    };
    final url = Uri.parse('https://ysw123.xyz/auth/${loginPlatform.name}');
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
      } else {
        // 실패
        logger.d("Fail to load ${data}. status code : ${response.statusCode}");
        return false;
      }
    } catch (e) {
      logger.d("error : ${e}");
      return false;
    }
  }
}
