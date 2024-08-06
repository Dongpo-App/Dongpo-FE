import 'package:dongpo_test/screens/login/login_platform.dart';

abstract class SocialLogin{
  Future<String?> isKakaoLogin();

  Future<String?> isNaverLogin();

  Future<bool> isLogout(LoginPlatform loginPlatform);
}
