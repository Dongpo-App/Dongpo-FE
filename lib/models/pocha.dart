class MyData {
  late int id;
  String? name;
  late double latitude;
  late double longitude;
  String? openTime;
  String? closeTime;
  int? memberId;
  String? status;
  List<String>? operatingDays;
  List<String>? payMethods;
  bool? toiletValid;

  MyData(
      {required this.id,
      this.name,
      required this.latitude,
      required this.longitude,
      this.openTime,
      this.closeTime,
      this.memberId,
      this.status,
      this.operatingDays,
      this.payMethods,
      this.toiletValid});

  MyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    memberId = json['memberId'];
    status = json['status'];
    operatingDays = json['operatingDays']?.cast<String>() ?? [];
    payMethods = json['payMethods']?.cast<String>() ?? [];
    toiletValid = json['toiletValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['openTime'] = openTime;
    data['closeTime'] = closeTime;
    data['memberId'] = memberId;
    data['status'] = status;
    data['operatingDays'] = operatingDays;
    data['payMethods'] = payMethods;
    data['toiletValid'] = toiletValid;
    return data;
  }
}
