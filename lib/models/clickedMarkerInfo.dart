class MarkerInfo {
  final int id;
  final String name;
  final String address;
  final String status;
  final String openPossibility;
  final bool isBookmarked;
  final List<String> reviewPics;

  MarkerInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
    required this.openPossibility,
    required this.isBookmarked,
    required this.reviewPics,
  });

  // 서버에서 받은 JSON 데이터를 Dart 객체로 변환하는 factory 메서드
  factory MarkerInfo.fromJson(Map<String, dynamic> json) {
    return MarkerInfo(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      status: json['status'],
      openPossibility: json['openPossibility'],
      isBookmarked: json['isBookmarked'],
      reviewPics: List<String>.from(json['reviewPics']), // 리스트 변환
    );
  }

  // Dart 객체를 다시 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'status': status,
      'openPossibility': openPossibility,
      'isBookmarked': isBookmarked,
      'reviewPics': reviewPics,
    };
  }
}
