class StoreSangse {
  final int id;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? openTime;
  final String? closeTime;
  final int? memberId;
  final int? reportCount;
  final bool? isToiletValid;
  final String? status;
  final List<String>? operatingDays;
  final List<String>? payMethods;
  final List<Review>? reviews;
  final String? openPossibility;
  final bool? isBookmarked;

  StoreSangse({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.openTime,
    required this.closeTime,
    required this.memberId,
    required this.reportCount,
    required this.isToiletValid,
    required this.status,
    required this.operatingDays,
    required this.payMethods,
    required this.reviews,
    required this.openPossibility,
    required this.isBookmarked,
  });

  factory StoreSangse.fromJson(Map<String, dynamic> json) {
    return StoreSangse(
      id: json['id'] as int,
      name: json['name'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      memberId: json['memberId'] as int?,
      reportCount: json['reportCount'] as int?,
      isToiletValid: json['isToiletValid'] as bool?,
      status: json['status'] as String?,
      operatingDays: json['operatingDays'] != null
          ? List<String>.from(json['operatingDays'])
          : null,
      payMethods: json['payMethods'] != null
          ? List<String>.from(json['payMethods'])
          : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((reviewJson) => Review.fromJson(reviewJson))
              .toList()
          : null,
      openPossibility: json['openPossibility'] as String?,
      isBookmarked: json['isBookmarked'] as bool?,
    );
  }
}

class Review {
  final int? id;
  final int? storeId;
  final int? memberId;
  final int? reviewStar;
  final String? text;
  final List<String>? reviewPics;
  final String? registerDate;

  Review({
    required this.id,
    required this.storeId,
    required this.memberId,
    required this.reviewStar,
    required this.text,
    required this.reviewPics,
    required this.registerDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int?,
      storeId: json['storeId'] as int?,
      memberId: json['memberId'] as int?,
      reviewStar: json['reviewStar'] as int?,
      text: json['text'] as String?,
      reviewPics: json['reviewPics'] != null
          ? List<String>.from(json['reviewPics'])
          : null,
      registerDate: json['registerDate'] as String?,
    );
  }
}
