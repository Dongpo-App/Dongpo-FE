import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class KakaoNaverLogin implements SocialLogin{
  @override
  Future<bool> isKakaoLogin() async {
    OAuthToken kakaoToken;
    try {
      // 카카오톡 실행 가능 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();
      if (await isInstalled) {
        try {
          // 카카오톡으로 로그인
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          if (e is PlatformException && e.code == "CANCELED") {
            return false;
          }
          try {
            kakaoToken = await UserApi.instance.loginWithKakaoAccount();
            logger.d("kakao accessToken : ${kakaoToken.accessToken}");
            return true;
          } catch (e) {
            return false;
          }
        }
      } else {
        try {
          // 카카오톡 어플이 없는 경우 -> 카카오 계정으로 로그인 유도
          kakaoToken = await UserApi.instance.loginWithKakaoAccount();
          logger.d("kakao accessToken : ${kakaoToken.accessToken}");
          return true;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isKakaoLogout() async{
    try {
      // logout 실행 코드. SDK에서 토큰 삭제
      await UserApi.instance.unlink();
      return true;
    } catch (error){
      return false;
    }
  }

  @override
  Future<bool> isNaverLogin() async {
    NaverLoginResult result;
    try {
      // 네이버 로그인 시도
      result = await FlutterNaverLogin.logIn();
      NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
      logger.d("naver login token : ${token.accessToken}");
      return true;
    } catch (e) {
      logger.d("naver login error : ${e}");
      return false;
    }
  }

  @override
  Future<bool> isNaverLogout() async {
    try {
      await FlutterNaverLogin.logOut();
      return true;
    } catch (e) {
      logger.d("naver logout error : ${e}");
      return false;
    }
  }

}