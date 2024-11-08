class StoreMarker {
  late int id;
  late String name;
  late double latitude;
  late double longitude;
  late String status;
  late String openPossibility;
  late bool isBookmarked;

  StoreMarker({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.openPossibility,
    required this.isBookmarked,
  });

  StoreMarker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    openPossibility = json['openPossibility'];
    isBookmarked = json['isBookmarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['openPossibility'] = openPossibility;
    data['isBookmarked'] = isBookmarked;
    return data;
  }
}
