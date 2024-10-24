class AddStoreRequest {
  late String name;
  late String address;
  late double latitude;
  late double longitude;
  String? openTime;
  String? closeTime;
  late bool isToiletValid;
  List<String>? operatingDays;
  List<String>? payMethods;
  double currentLatitude;
  double currentLongitude;

  AddStoreRequest({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.openTime,
    this.closeTime,
    required this.isToiletValid,
    this.operatingDays,
    this.payMethods,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['openTime'] = openTime;
    data['closeTime'] = closeTime;
    data['isToiletValid'] = isToiletValid;
    data['operatingDays'] = operatingDays;
    data['payMethods'] = payMethods;
    data['currentLatitude'] = currentLatitude;
    data['currentLongitude'] = currentLongitude;
    return data;
  }
}
