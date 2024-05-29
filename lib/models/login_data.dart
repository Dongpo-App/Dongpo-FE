class LoginData{
  String? grantType;
  String? claims;
  String? accessToken;
  String? refreshToken;

  LoginData({
    this.grantType,
    this.claims,
    this.refreshToken,
    this.accessToken
  });

  LoginData.fromJson(Map<String, String> json) {
    grantType = json['grantType'];
    claims = json['claims'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}