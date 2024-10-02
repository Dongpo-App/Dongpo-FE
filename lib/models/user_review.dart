class UserReview {
  late final int id;
  late final int storeId;
  late final int memberId;
  late final int reviewStar;
  late final String text;
  late final DateTime registerDate;
  late final String status;
  late final int? reportCount;


  UserReview({
    required this.id,
    required this.storeId,
    required this.memberId,
    required this.reviewStar,
    required this.text,
    required this.registerDate,
    required this.status,
    this.reportCount,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      id: json['id'],
      storeId: json['storeId'],
      memberId: json['memberId'],
      reviewStar: json['reviewStar'],
      text: json['text'],
      // String을 DateTime으로 변환
      registerDate: DateTime.parse(json['registerDate']),
      status: json['status'],
      reportCount: json['reportCount'],
    );
  }

  // getter
  int getId() {
    return id;
  }
  int getStoreId(){
    return storeId;
  }
  int getMemberId(){
    return memberId;
  }
  int getReviewStar(){
    return reviewStar;
  }
  String getText(){
    return text;
  }
  DateTime getRegisterDate(){
    return registerDate;
  }
  String getStatus(){
    return status;
  }
}

