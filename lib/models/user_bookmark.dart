class UserBookmark {
  late final int id;
  late final String storeName;
  late final int storeId;

  UserBookmark({
    required this.id,
    required this.storeName,
    required this.storeId,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory UserBookmark.fromJson(Map<String, dynamic> json) {
    return UserBookmark(
      id: json['id'],
      storeName: json['storeName'],
      storeId: json['storeId'],
    );
  }

  // getter
  int getId() {
    return id;
  }
  String getStoreName(){
    return storeName;
  }
  int getStoreId(){
    return storeId;
  }
}

