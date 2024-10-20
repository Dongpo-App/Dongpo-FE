class RecommendGenderStore {
  late final int id;
  late final String name;
  late final String address;
  late final String ageGroup;

  RecommendGenderStore({
    required this.id,
    required this.name,
    required this.address,
    required this.ageGroup,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory RecommendGenderStore.fromJson(Map<String, dynamic> json) {
    return RecommendGenderStore(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      ageGroup: json['ageGroup'],
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

  String getAgeGroup() {
    return ageGroup;
  }
}
