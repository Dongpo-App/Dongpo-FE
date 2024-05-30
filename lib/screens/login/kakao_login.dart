import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin implements SocialLogin{
  @override
  Future<bool> isKakaoLogin() async {
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
            await UserApi.instance.loginWithKakaoAccount();
            return true;
          } catch (e) {
            return false;
          }
        }
      } else {
        try {
          // 카카오톡 어플이 없는 경우 -> 카카오 계정으로 로그인 유도
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      logger.d('kakaologin4');
      return false;
    }
  }

  @override
  Future<bool> isLogout() async{
    try {
      // logout 실행 코드. SDK에서 토큰 삭제
      await UserApi.instance.unlink();
      return true;
    } catch (error){
      return false;
    }
  }

}