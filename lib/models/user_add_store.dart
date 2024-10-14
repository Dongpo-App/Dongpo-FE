class UserAddStore {
  late final int id;
  late final String name;
  late final String address;
  late final DateTime registerDate;

  UserAddStore({
    required this.id,
    required this.name,
    required this.address,
    required this.registerDate,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory UserAddStore.fromJson(Map<String, dynamic> json) {
    return UserAddStore(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      // String을 DateTime으로 변환
      registerDate: DateTime.parse(json['registerDate']),
    );
  }

  // getter
  int getId() {
    return id;
  }

  String getName() {
    return name;
  }

  String getAddress() {
    return address;
  }

  DateTime getRegisterDate() {
    return registerDate;
  }
}
