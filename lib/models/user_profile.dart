class UserProfile {
  final String nickname; // 닉네임
  final String? profilePic; // 프로필사진 URL
  final int registerCount; // 점포 등록 횟수
  final int titleCount; // 칭호 보유 개수
  final int presentCount; // 선물함 선물 개수

  UserProfile({
    required this.nickname,
    this.profilePic,
    required this.registerCount,
    required this.titleCount,
    required this.presentCount,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'],
      profilePic: json['profilePic'],
      registerCount: json['registerCount'],
      titleCount: json['titleCount'],
      presentCount: json['presentCount'],
    );
  }
}
