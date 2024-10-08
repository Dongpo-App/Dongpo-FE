import 'package:dongpo_test/models/pocha.dart';

abstract class StoreServiceInterface {
  // 현재 카메라 위치 기준 주변 점포 조회
  Future<List<MyData>> getSotreByCurrentLocation();
  // 점포 등록
  Future<void> addStore(MyData storeInfo);
  // 점포 상세 조회
  Future<MyData> getStoreDetail(int id);
  // 점포 삭제
  Future<void> deleteStore(int id);
  // 점포 정보 수정
  Future<void> updateStore(int id, MyData update);
  // 점포 간략 정보 조회
  Future<MyData> getStoreSummary(int id);
  // 리뷰 등록
  Future<void> addReview(int id, Map<String, dynamic> request);
}
