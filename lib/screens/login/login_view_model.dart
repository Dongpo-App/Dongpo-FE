import 'package:dongpo_test/screens/login/social_login.dart';

import '../../main.dart';

class LoginViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;

  LoginViewModel(this._socialLogin);

  Future kakaoLogin() async {
    isLogined = await _socialLogin.kakaoLogin();
    if (isLogined) {
      // 카카오 로그인이 성공함
      logger.d("Login Success");
    } else {
      logger.d("fail .....");
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
  }
}