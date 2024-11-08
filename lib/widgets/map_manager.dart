import 'dart:ui';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/store/clicked_marker_info.dart';
import 'package:dongpo_test/models/store/store_detail.dart';
import 'package:dongpo_test/models/store/store_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class MapManager {
  MapManager._privateConstructor();
  // 싱글톤 인스턴스
  static final MapManager _instance = MapManager._privateConstructor();
  // 맵 컨트롤러
  late NaverMapController mapController;
  // 마커 리스트
  List<NMarker> markers = [];
  // 마커 리스트내 점포의 정보
  List<StoreMarker> storeList = [];
  // 현재 선택된 마커의 점포 정보
  StoreDetail? selectedDetail;
  MarkerInfo? selectedSummary;
  StoreMarker? selectedMarker;

  factory MapManager() => _instance;

  // 초기화 메서드
  void initialize(NaverMapController controller) {
    mapController = controller;
  }

  Future<void> moveCamera(NLatLng position) async {
    try {
      await mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: position,
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      logger.e(e);
    }
  }

  // 현재 위치를 NLatLng 으로 받기
  Future<NLatLng> getCurrentNLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return NLatLng(position.latitude, position.longitude);
  }

  void addMarkers(List<StoreMarker> dataList,
      void Function(NMarker marker, StoreMarker store) listener) {
    storeList = dataList;
    try {
      const defaultMarkerSize = Size(32, 32);

      for (StoreMarker data in storeList) {
        NMarker marker = NMarker(
          id: data.id.toString(),
          position: NLatLng(data.latitude, data.longitude),
          icon: const NOverlayImage.fromAssetImage(
              'assets/icons/default_marker.png'),
        );
        marker.setSize(defaultMarkerSize);

        marker.setOnTapListener((overlay) {
          selectedMarker = data;
          listener(marker, data);
        });
        mapController.addOverlay(marker);
        markers.add(marker);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> clearMarkers() async {
    await mapController.clearOverlays();
    markers.clear();
  }

  Future<int> calcDistanceStore() async {
    if (selectedMarker == null) return 0;
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return Geolocator.distanceBetween(
            userLocation.latitude,
            userLocation.longitude,
            selectedMarker!.latitude,
            selectedMarker!.longitude)
        .floor();
  }
}
