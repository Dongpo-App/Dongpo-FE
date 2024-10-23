class LoginResponse {
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? data;

  LoginResponse({
    required this.statusCode,
    this.message,
    this.data,
  });
  // success, // 200
  // canceled, // 사용자 취소
  // duplicateEmail, // 409
  // requiredSignUp,
  // networkError,
  // serverError, // 500번대
  // unknownError,
}
