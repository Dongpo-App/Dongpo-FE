class StoreDetail {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String openTime;
  final String closeTime;
  final int memberId;
  final String memberNickname;
  final int reportCount;
  final bool isToiletValid;
  final String status;
  final List<String> operatingDays;
  final List<String> payMethods;
  final List<Review> reviews;
  final List<MostVisitMembers>? mostVisitMembers;
  final String openPossibility;
  final bool isBookmarked;
  final int? visitSuccessfulCount;
  final int? visitFailCount;
  final int? bookmarkCount;

  StoreDetail({
    required this.bookmarkCount,
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.openTime,
    required this.closeTime,
    required this.memberId,
    required this.memberNickname,
    required this.reportCount,
    required this.isToiletValid,
    required this.status,
    required this.operatingDays,
    required this.payMethods,
    required this.reviews,
    this.mostVisitMembers,
    required this.openPossibility,
    required this.isBookmarked,
    this.visitFailCount,
    this.visitSuccessfulCount,
  });

  factory StoreDetail.fromJson(Map<String, dynamic> json) {
    return StoreDetail(
      bookmarkCount: json['bookmarkCount'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      memberId: json['memberId'] as int,
      memberNickname: json['memberNickname'] as String,
      reportCount: json['reportCount'] as int,
      isToiletValid: json['isToiletValid'] as bool,
      status: json['status'] as String,
      operatingDays: json['operatingDays'] != null
          ? List<String>.from(json['operatingDays'])
          : [],
      payMethods: json['payMethods'] != null
          ? List<String>.from(json['payMethods'])
          : [],
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((reviewJson) => Review.fromJson(reviewJson))
              .toList()
          : [],
      mostVisitMembers: json['mostVisitMembers'] != null
          ? (json['mostVisitMembers'] as List)
              .map((mostVisitMembersJson) =>
                  MostVisitMembers.fromJson(mostVisitMembersJson))
              .toList()
          : [],
      openPossibility: json['openPossibility'] as String,
      isBookmarked: json['isBookmarked'] as bool,
      visitFailCount: json['visitFailCount'] as int?,
      visitSuccessfulCount: json['visitSuccessfulCount'] as int?,
    );
  }
}

class Review {
  final int? id;
  final int? storeId;
  final int? memberId;
  final double? reviewStar;
  final String? memberNickname;
  final String? memberProfilePic;
  final String? text;
  final List<String>? reviewPics;
  final DateTime registerDate;
  final String? memberMainTitle;

  Review({
    required this.memberMainTitle,
    required this.memberNickname,
    required this.id,
    required this.storeId,
    required this.memberId,
    required this.reviewStar,
    required this.memberProfilePic,
    required this.text,
    required this.reviewPics,
    required this.registerDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      memberMainTitle: json['memberMainTitle'] as String?,
      memberNickname: json['memberNickname'] as String?,
      id: json['id'] as int?,
      storeId: json['storeId'] as int?,
      memberId: json['memberId'] as int?,
      reviewStar: json['reviewStar'] as double?,
      text: json['text'] as String?,
      memberProfilePic: json['memberProfilePic'],
      reviewPics: json['reviewPics'] != null
          ? List<String>.from(json['reviewPics'])
          : null,
      registerDate: DateTime.parse(json['registerDate']),
    );
  }
}

class MostVisitMembers {
  late final int? id;
  late final String? nickname;
  late final String? title;
  late final String? profilePic;

  MostVisitMembers({
    this.id,
    this.nickname,
    this.title,
    this.profilePic,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory MostVisitMembers.fromJson(Map<String, dynamic> json) {
    return MostVisitMembers(
      id: json['id'],
      nickname: json['nickname'],
      title: json['mainTitle'],
      profilePic: json['profilePic'],
    );
  }
}
