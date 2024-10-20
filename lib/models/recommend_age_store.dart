class RecommendAgeStore {
  late final int id;
  late final String name;
  late final String address;
  late final String gender;

  RecommendAgeStore({
    required this.id,
    required this.name,
    required this.address,
    required this.gender,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory RecommendAgeStore.fromJson(Map<String, dynamic> json) {
    return RecommendAgeStore(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      gender: json['gender'],
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

  String getGender() {
    return gender;
  }
}
