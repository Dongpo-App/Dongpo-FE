class TokenExpiredException implements Exception {
  // 토큰 재발급 실패시 해당 예외가 뜨면 로그인 화면으로 보낼 예정
  final String message;

  TokenExpiredException([this.message = "RefreshToken has expired."]);

  @override
  String toString() => message;
}
