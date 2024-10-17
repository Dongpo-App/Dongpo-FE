class RecommendStore {
  late final int id;
  late final String name;
  late final String address;
  late final String businessPotential;

  RecommendStore({
    required this.id,
    required this.name,
    required this.address,
    required this.businessPotential,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory RecommendStore.fromJson(Map<String, dynamic> json) {
    return RecommendStore(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      // String을 DateTime으로 변환
      businessPotential: json['businessPotential'],
    );
  }

  // Map을 RecommendStore 객체로 변환하는 factory 생성자
  factory RecommendStore.fromMap(Map<String, dynamic> map) {
    return RecommendStore(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      businessPotential: map['businessPotential'],
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

  String getBusinessPotential() {
    return businessPotential;
  }
}
