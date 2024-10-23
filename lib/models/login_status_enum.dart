enum LoginStatus {
  success, // 200
  canceled, // 사용자 취소
  duplicateEmail, // 409
  networkError,
  serverError, // 500번대
  unknownError,
}
