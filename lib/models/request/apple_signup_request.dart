class AppleSignupRequest {
  final String nickname;
  final String birthday;
  final String gender;
  final String socialId;
  final String email;
  final bool isServiceTermsAgreed;
  final bool isMarketingTermsAgreed;

  AppleSignupRequest({
    required this.nickname,
    required this.birthday,
    required this.gender,
    required this.socialId,
    required this.email,
    required this.isServiceTermsAgreed,
    required this.isMarketingTermsAgreed,
  });

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname,
      "birthday": birthday,
      "gender": gender,
      "socialId": socialId,
      "email": email,
      "isServiceTermsAgreed": isServiceTermsAgreed,
      "isMarketingTermsAgreed": isMarketingTermsAgreed,
    };
  }
}
