class UserReview {
  late final int id;
  late final int storeId;
  late final int reviewStar;
  late final String text;
  late final DateTime registerDate;
  late final String status;
  late final int reportCount;


  UserReview({
    required this.id,
    required this.storeId,
    required this.reviewStar,
    required this.text,
    required this.registerDate,
    required this.status,
    required this.reportCount,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      id: json['id'],
      storeId: json['storeId'],
      reviewStar: json['reviewStar'],
      text: json['text'],
      registerDate: json['registerDate'],
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
  int getReportCount(){
    return reportCount;
  }
}

