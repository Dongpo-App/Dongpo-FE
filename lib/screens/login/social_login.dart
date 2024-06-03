abstract class SocialLogin{
  Future<bool> isKakaoLogin();

  Future<bool> isNaverLogin();

  Future<bool> isKakaoLogout();

  Future<bool> isNaverLogout();
}