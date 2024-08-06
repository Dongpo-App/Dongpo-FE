enum LoginPlatform {
  kakao,
  naver,
  none, // logout
}
extension ParseToString on Enum {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

extension LoginPlatformExtension on LoginPlatform {
  static LoginPlatform fromString(String? string) {
    return LoginPlatform.values.firstWhere((e) => e.toShortString() == string, orElse: () => throw Exception('Invalid platform string'));
  }
}

