class AddClass {
  String? name;
  String? address;
  double? latitude;
  double? longitude;
  String? openTime;
  String? closeTime;
  bool? isToiletValid;
  List<String>? operatingDays;
  List<String>? payMethods;

  AddClass(
      {this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.openTime,
      this.closeTime,
      this.isToiletValid,
      this.operatingDays,
      this.payMethods});

  AddClass.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    isToiletValid = json['isToiletValid'];
    operatingDays = json['operatingDays'].cast<String>();
    payMethods = json['payMethods'].cast<String>();
  }

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
    return data;
  }
}
