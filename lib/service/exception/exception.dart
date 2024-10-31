class TokenExpiredException implements Exception {
  // 토큰 재발급 실패시 해당 예외가 뜨면 로그인 화면으로 보낼 예정
  final String message;

  TokenExpiredException([this.message = "RefreshToken has expired."]);

  @override
  String toString() => message;
}

class ServerLogoutException implements Exception {
  // 서버 로그아웃 진행중 실패시 비정상적인 로그아웃
  final String message;

  ServerLogoutException([this.message = "failed to logout with server"]);

  @override
  String toString() => message;
}

class AccountDeletionFailureException implements Exception {
  final String message;

  AccountDeletionFailureException(
      [this.message = "failed to delete your account"]);

  @override
  String toString() => message;
}
