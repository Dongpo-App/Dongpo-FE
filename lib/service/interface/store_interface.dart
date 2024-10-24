import 'package:dongpo_test/models/clickedMarkerInfo.dart';
import 'package:dongpo_test/models/request/add_store_request.dart';
import 'package:dongpo_test/models/store_detail.dart';
import 'package:dongpo_test/models/pocha.dart';
import 'package:image_picker/image_picker.dart';

abstract class StoreServiceInterface {
  // 현재 카메라 위치 기준 주변 점포 조회
  Future<List<MyData>> getStoreByCurrentLocation(double lat, double lng);
  // 점포 등록
  Future<bool> addStore(AddStoreRequest storeInfo);
  // 점포 상세 조회
  Future<StoreSangse> getStoreDetail(int id);
  // 점포 삭제
  Future<bool> deleteStore(int id);
  // 점포 정보 수정
  Future<bool> updateStore(int id, MyData update);
  // 점포 간략 정보 조회
  Future<MarkerInfo> getStoreSummary(int id);
  // 리뷰 등록
  Future<bool> addReview({
    required int id,
    required String reviewText,
    required List<XFile> images,
    required int rating,
  });
}
