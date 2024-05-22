class Jumpho {
  int? id;
  String? name;
  String? location;
  String? openTime;
  String? closeTime;
  int? memberId;
  String? status;
  List<String>? operatingDays;
  List<String>? payMethods;
  bool? toiletValid;

  Jumpho(
      {this.id,
      this.name,
      this.location,
      this.openTime,
      this.closeTime,
      this.memberId,
      this.status,
      this.operatingDays,
      this.payMethods,
      this.toiletValid});

  Jumpho.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    memberId = json['memberId'];
    status = json['status'];
    operatingDays = json['operatingDays'].cast<String>();
    payMethods = json['payMethods'].cast<String>();
    toiletValid = json['toiletValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['memberId'] = this.memberId;
    data['status'] = this.status;
    data['operatingDays'] = this.operatingDays;
    data['payMethods'] = this.payMethods;
    data['toiletValid'] = this.toiletValid;
    return data;
  }
}
