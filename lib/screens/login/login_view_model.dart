import 'package:dongpo_test/screens/login/social_login.dart';

import 'package:dongpo_test/main.dart';
import 'login_platform.dart';

class LoginViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  bool isLogouted = false;
  LoginPlatform loginPlatform = LoginPlatform.none;

  LoginViewModel(this._socialLogin);

  Future kakaoLogin() async {
    isLogined = await _socialLogin.isKakaoLogin();
    if (isLogined) {
      // 카카오 로그인이 성공함
      loginPlatform = LoginPlatform.kakao;
      logger.d("kakao login success");
    } else {
      logger.d("kakao login fail");
    }
  }

  Future naverLogin() async {
    isLogined = await _socialLogin.isNaverLogin();
    loginPlatform = LoginPlatform.naver;
    if(isLogined) {
      // 네이버 로그인 성공함
      logger.d("naver login success");
    } else {
      logger.d("naver login fail");
    }
  }

  Future logout() async {
    logger.d("${loginPlatform} is logout");
    isLogouted = await _socialLogin.isLogout(loginPlatform);
    if(isLogouted){
      // 로그아웃 성공
      loginPlatform = LoginPlatform.none;
      isLogined = false;
    }
  }
}