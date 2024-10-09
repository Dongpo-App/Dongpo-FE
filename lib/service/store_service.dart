import 'package:dongpo_test/models/pocha.dart';

class ApiService {
  final serverUrl = "https://ysw123.xyz";
  late String accessToken;
  late String refreshToken;

  @override
  Future<void> addReview(int id, Map<String, dynamic> request) {
    // TODO: implement addReview
    throw UnimplementedError();
  }

  @override
  Future<void> addStore(MyData storeInfo) {
    // TODO: implement addStore
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStore(int id) {
    // TODO: implement deleteStore
    throw UnimplementedError();
  }

  @override
  Future<List<MyData>> getSotreByCurrentLocation() {
    // TODO: implement getSotreByCurrentLocation
    throw UnimplementedError();
  }

  @override
  Future<MyData> getStoreDetail(int id) {
    // TODO: implement getStoreDetail
    throw UnimplementedError();
  }

  @override
  Future<MyData> getStoreSummary(int id) {
    // TODO: implement getStoreSummary
    throw UnimplementedError();
  }

  @override
  Future<void> updateStore(int id, MyData update) {
    // TODO: implement updateStore
    throw UnimplementedError();
  }
}
