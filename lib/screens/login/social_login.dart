import 'package:dongpo_test/screens/login/login_platform.dart';

abstract class SocialLogin{
  Future<bool> isKakaoLogin();

  Future<bool> isNaverLogin();

  Future<bool> isLogout(LoginPlatform loginPlatform);
}