import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'login_platform.dart';

class KakaoNaverLogin implements SocialLogin {
  @override
  Future<String?> isKakaoLogin() async {
    try {
      // 카카오톡 실행 가능 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();
      if (await isInstalled) {
        try {
          // 카카오톡으로 로그인
          final oauthToken = await UserApi.instance.loginWithKakaoTalk();
          logger.d(
              "kakaoTalk login accessToken : ${oauthToken.accessToken.toString()}");
          return oauthToken.accessToken.toString();
        } catch (e) {
          logger.d("kakaoTalk login errer : $e");
          if (e is PlatformException && e.code == "CANCELED") {
            logger.d("e : ${e}");
            return null;
          }
          try {
            final kakaoToken = await UserApi.instance.loginWithKakaoAccount();
            logger.d(
                "kakaoAccount login accessToken : ${kakaoToken.accessToken}");
            return kakaoToken.accessToken.toString();
          } catch (e) {
            logger.d("e : ${e}");
            return null;
          }
        }
      } else {
        try {
          // 카카오톡 어플이 없는 경우 -> 카카오 계정으로 로그인 유도
          final kakaoToken = await UserApi.instance.loginWithKakaoAccount();
          logger
              .d("kakaoAccount login accessToken : ${kakaoToken.accessToken}");
          return kakaoToken.accessToken.toString();
        } catch (e) {
          logger.d("e : ${e}");
          return null;
        }
      }
    } catch (e) {
      logger.d("e : ${e}");
      return null;
    }
  }

  @override
  Future<String?> isNaverLogin() async {
    NaverLoginResult result;
    try {
      // 네이버 로그인 시도
      result = await FlutterNaverLogin.logIn();
      NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
      logger.d("naver login accessToken : ${token.accessToken}");
      return token.accessToken.toString();
    } catch (e) {
      logger.d("naver login error : ${e}");
      return null;
    }
  }

  @override
  Future<bool> isLogout(LoginPlatform loginPlatform) async {
    switch (loginPlatform) {
      case LoginPlatform.kakao:
        try {
          // logout 실행 코드. SDK에서 토큰 삭제
          await UserApi.instance.unlink();
          logger.d("${loginPlatform} : logout");
          return true;
        } catch (e) {
          logger.d("kakao logout error : ${e}");
          return false;
        }
      case LoginPlatform.naver:
        try {
          await FlutterNaverLogin.logOut();
          logger.d("${loginPlatform} : logout");
          return true;
        } catch (e) {
          logger.d("naver logout error : ${e}");
          return false;
        }

      case LoginPlatform.none:
        logger.d("login Platform none!");
        return true;
    }
  }
}
