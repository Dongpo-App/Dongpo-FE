class MyData {
  String id;
  String name;
  String address;
  double latitude;
  double longitude;
  String openTime;
  String closeTime;
  bool isToiletValid;
  List<String> operatingDays;
  List<String> payMethods;

  MyData({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.openTime,
    required this.closeTime,
    required this.isToiletValid,
    required this.operatingDays,
    required this.payMethods,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'openTime': openTime,
      'closeTime': closeTime,
      'isToiletValid': isToiletValid,
      'operatingDays': operatingDays,
      'payMethods': payMethods,
    };
  }
}
