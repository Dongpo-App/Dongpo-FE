class AppleSignupRequest {
  final String nickname;
  final String birthday;
  final String gender;
  final String socialId;
  final String email;

  AppleSignupRequest({
    required this.nickname,
    required this.birthday,
    required this.gender,
    required this.socialId,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname,
      "birthday": birthday,
      "gender": gender,
      "socialId": socialId,
      "email": email
    };
  }
}
