class LoginResponse {
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? data;

  LoginResponse({
    required this.statusCode,
    this.message,
    this.data,
  });
}

enum Status {
  success, // 성공
  serverError, // 서버에러
  duplicatedEmail, // 이메일 중복
  networkError, // 네트워크 에러
  validationFail, // 유효성 검사 실패 400
  unknownError,
}
