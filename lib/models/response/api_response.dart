class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T? data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
      int statusCode, Map<String, dynamic> json, T Function(dynamic) create,
      {String defaultMessage = "비어있는 메시지"}) {
    return ApiResponse(
        statusCode: statusCode,
        message: json['message'] ?? defaultMessage,
        data: json['data'] != null ? create(json['data']) : null);
  }
}

// enum Status {
//   success, // 성공
//   serverError, // 서버에러
//   duplicatedEmail, // 이메일 중복
//   networkError, // 네트워크 에러
//   validationFail, // 유효성 검사 실패 400
//   unknownError,
// }
