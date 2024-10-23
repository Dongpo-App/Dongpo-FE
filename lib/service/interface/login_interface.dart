import 'package:dongpo_test/models/login_status_enum.dart';

abstract class LoginServiceInterface {
  // 네이버 로그인
  Future<LoginStatus> naverLogin();
  // 카카오 로그인
  Future<LoginStatus> kakaoLogin();
  // 애플 로그인
  Future<LoginStatus> appleLogin();
  // 애플 탈퇴
  Future<bool> appleLeave();
  // 로그아웃
  Future<bool> logout();
}
