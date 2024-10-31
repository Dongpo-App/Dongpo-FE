import 'package:dongpo_test/models/response/api_response.dart';
import 'package:dongpo_test/models/request/apple_signup_request.dart';

abstract class LoginServiceInterface {
  // 네이버 로그인
  Future<ApiResponse> naverLogin();
  // 카카오 로그인
  Future<ApiResponse> kakaoLogin();
  // 애플 로그인
  Future<ApiResponse> appleLogin();
  // 애플 회원가입 (추가 정보 입력)
  Future<ApiResponse> appleSignup(AppleSignupRequest request);
  // 애플 탈퇴
  Future<bool> appleLeave();
  // 로그아웃
  Future<bool> logout();
}
