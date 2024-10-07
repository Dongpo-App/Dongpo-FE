class UserBookmark {
  late final int id;
  late final int storeId;
  late final String storeName;
  late final DateTime bookmarkDate;

  UserBookmark({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.bookmarkDate,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory UserBookmark.fromJson(Map<String, dynamic> json) {
    return UserBookmark(
      id: json['id'],
      storeId: json['storeId'],
      storeName: json['storeName'],
      // String을 DateTime으로 변환
      bookmarkDate: DateTime.parse(json['bookmarkDate']),
    );
  }

  // getter
  int getId() {
    return id;
  }

  String getStoreName() {
    return storeName;
  }

  int getStoreId() {
    return storeId;
  }

  DateTime getBookmarkDate() {
    return bookmarkDate;
  }
}
