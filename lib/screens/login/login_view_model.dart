import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../main.dart';

class LoginViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;

  LoginViewModel(this._socialLogin);

  Future kakaoLogin() async {
    isLogined = await _socialLogin.isKakaoLogin();
    if (isLogined) {
      // 카카오 로그인이 성공함
      logger.d("kakao login success");
    } else {
      logger.d("kakao login fail");
    }
  }

  Future kakakLogout() async {
    await _socialLogin.isKakaoLogout();
    isLogined = false;
  }

  Future naverLogin() async {
    isLogined = await _socialLogin.isNaverLogin();
    if(isLogined) {
      // 네이버 로그인 성공함
      logger.d("naver login success");
    } else {
      logger.d("naver login fail");
    }
  }

  Future naverLogout() async {
    await _socialLogin.isNaverLogout();
    isLogined = false;
  }
}