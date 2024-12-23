class UserReview {
  late final int id;
  late final int storeId;
  late final String storeName;
  late final double reviewStar;
  late final String reviewText ;
  late final List<String> reviewPics;
  late final DateTime registerDate;

  UserReview({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.reviewStar,
    required this.reviewText ,
    required this.reviewPics,
    required this.registerDate,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      id: json['id'] ?? 0,
      storeId: json['storeId'] ?? 0,
      storeName: json['storeName'] ?? '',
      reviewStar: json['reviewStar'] ?? 0,
      reviewText : json['reviewText'] ?? '',
      // reviewPics 필드가 null일 수 있으므로 기본값을 빈 리스트로 설정
      reviewPics: List<String>.from(json['reviewPics'] ?? []),
      // String을 DateTime으로 변환
      registerDate: DateTime.parse(json['registerDate'] ?? ''),
    );
  }

  // getter
  int getId() {
    return id;
  }
  int getStoreId(){
    return storeId;
  }
  String getStoreName(){
    return storeName;
  }
  double getReviewStar(){
    return reviewStar;
  }
  String getReviewText (){
    return reviewText ;
  }
  List<String> getReviewPics(){
    return reviewPics;
  }
  DateTime getRegisterDate(){
    return registerDate;
  }
}

