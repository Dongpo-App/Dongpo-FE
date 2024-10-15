class CommunityRank {
  late final String nickname; // 닉네임
  late final String title; // 칭호
  late final String? pic; // 프로필사진 URL
  late final int count; // 등수

  CommunityRank({
    required this.nickname,
    required this.title,
    this.pic,
    required this.count,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory CommunityRank.fromJson(Map<String, dynamic> json) {
    return CommunityRank(
      nickname: json['nickname'],
      title: json['title'],
      pic: json['pic'],
      count: json['count'],
    );
  }

  // getter
  String getNickname() {
    return nickname;
  }
  String getTitle() {
    return title;
  }
  String? getPic() {
    return pic;
  }
  int getCount() {
    return count;
  }
}

