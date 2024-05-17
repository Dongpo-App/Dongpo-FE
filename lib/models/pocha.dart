class Jompho {
  String id;
  String name;
  int location;
  int? openTime;
  int? closeTime;
  int memberId;
  String status;
  List<String> operatingDays;
  List<String> payMethods;
  bool toiletValid;

  Jompho({
    required this.id,
    required this.name,
    required this.location,
    this.openTime,
    this.closeTime,
    required this.memberId,
    required this.status,
    required this.operatingDays,
    required this.payMethods,
    required this.toiletValid,
  });

  //Json
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'openTime': openTime,
      'closeTime': closeTime,
      'memberId': memberId,
      'status': status,
      'operatingDays': operatingDays,
      'payMethods': payMethods,
      'toiletValid': toiletValid,
    };
  }
}
