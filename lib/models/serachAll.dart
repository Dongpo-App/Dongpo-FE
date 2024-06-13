// class MyData {
//   int? id;
//   String? name;
//   double? latitude;
//   double? longitude;
//   String? openTime;
//   String? closeTime;
//   int? memberId;
//   String? status;
//   List<String>? operatingDays;
//   List<String>? payMethods;
//   bool? toiletValid;

//   MyData(
//       {this.id,
//       this.name,
//       this.latitude,
//       this.longitude,
//       this.openTime,
//       this.closeTime,
//       this.memberId,
//       this.status,
//       this.operatingDays,
//       this.payMethods,
//       this.toiletValid});

//   MyData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     openTime = json['openTime'];
//     closeTime = json['closeTime'];
//     memberId = json['memberId'];
//     status = json['status'];
//     operatingDays = json['operatingDays'].cast<String>();
//     payMethods = json['payMethods'].cast<String>();
//     toiletValid = json['toiletValid'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['openTime'] = this.openTime;
//     data['closeTime'] = this.closeTime;
//     data['memberId'] = this.memberId;
//     data['status'] = this.status;
//     data['operatingDays'] = this.operatingDays;
//     data['payMethods'] = this.payMethods;
//     data['toiletValid'] = this.toiletValid;
//     return data;
//   }
// }
