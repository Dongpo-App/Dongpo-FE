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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['isToiletValid'] = this.isToiletValid;
    data['operatingDays'] = this.operatingDays;
    data['payMethods'] = this.payMethods;
    return data;
  }
}
