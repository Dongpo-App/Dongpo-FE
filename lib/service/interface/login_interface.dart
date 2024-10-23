import 'package:dongpo_test/models/login_response.dart';
import 'package:dongpo_test/models/request/apple_signup_request.dart';

abstract class LoginServiceInterface {
  // 네이버 로그인
  Future<LoginResponse> naverLogin();
  // 카카오 로그인
  Future<LoginResponse> kakaoLogin();
  // 애플 로그인
  Future<LoginResponse> appleLogin();
  // 애플 회원가입 (추가 정보 입력)
  Future<LoginResponse> appleSignup(AppleSignupRequest request);
  // 애플 탈퇴
  Future<bool> appleLeave();
  // 로그아웃
  Future<bool> logout();
}
