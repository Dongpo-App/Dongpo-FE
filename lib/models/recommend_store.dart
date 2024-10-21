class RecommendStore {
  late final int id;
  late final String name;
  late final String address;

  RecommendStore({
    required this.id,
    required this.name,
    required this.address,
  });

  // JSON 데이터를 클래스 인스턴스로 변환하는 factory 생성자
  factory RecommendStore.fromJson(Map<String, dynamic> json) {
    return RecommendStore(
      id: json['id'],
      name: json['name'],
      address: json['address'],
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
}

// 전체 응답을 처리할 클래스 추가
class RecommendResponse {
  late final List<RecommendStore> stores;
  late final String message;

  RecommendResponse({
    required this.stores,
    required this.message,
  });

  factory RecommendResponse.fromJson(Map<String, dynamic> json) {
    return RecommendResponse(
      stores: (json['data'] as List)
          .map((storeJson) => RecommendStore.fromJson(storeJson))
          .toList(),
      message: json['message'],
    );
  }

  // getter
  List<RecommendStore> getStores(){
    return stores;
  }
  String getMessage(){
    return message;
  }
}