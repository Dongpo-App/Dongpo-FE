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
  factory MapManager() => _instance;
  // 맵 컨트롤러
  late NaverMapController mapController;
  // 마커 리스트
  List<NMarker> markers = [];
  // 마커 리스트내 점포의 정보
  List<StoreMarker> storeList = [];
  // 현재 선택된 마커의 점포 정보
  NMarker? selectedMarker; // 선택된 마커
  StoreMarker? selectedMarkerInfo; // 선택된 마커의 정보
  MarkerInfo? selectedSummary; // 선택된 점포 개요
  StoreDetail? selectedDetail; // 선택된 점포 상세

  bool _isControllerInit = false;

  // 현재 위치를 NLatLng 으로 받기
  static Future<NLatLng> getCurrentNLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return NLatLng(position.latitude, position.longitude);
  }

  // 초기화 메서드
  void initialize(NaverMapController controller) async {
    if (!_isControllerInit) {
      logger.d("controller is init : ${controller.hashCode}");
      mapController = controller;
      _isControllerInit = true;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  // 리셋 메서드 (로그아웃 시)
  void reset() {
    logger.d("MapManager is reset");
    _isControllerInit = false;
    mapController.dispose();
    markers.clear();
    storeList.clear();
    selectedMarker = null;
    selectedMarkerInfo = null;
    selectedSummary = null;
    selectedDetail = null;
  }

  // 카메라 이동
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

  // 마커 추가
  void addMarkers(List<StoreMarker> dataList,
      void Function(NMarker marker, StoreMarker store) listener) {
    storeList = dataList;
    try {
      logger.d("add markers");
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
          logger.d("marger ontap ${overlay.info.id}");
          selectedMarkerInfo = data;
          listener(marker, data);
        });
        mapController.addOverlay(marker);
        markers.add(marker);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  // 선택 마커 초기화
  void deselectMarker() {
    if (selectedMarker == null) return;
    selectedMarker!.setIcon(
        const NOverlayImage.fromAssetImage('assets/icons/default_marker.png'));
    selectedMarker = null;
  }

  //마커 삭제
  Future<void> clearMarkers() async {
    await mapController.clearOverlays();
    markers.clear();
  }

  // 사용자와 점포 거리 계산
  Future<String> calcDistanceStore() async {
    String result = "";
    if (selectedMarkerInfo == null) return result;
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double distanceMeter = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        selectedMarkerInfo!.latitude,
        selectedMarkerInfo!.longitude);
    // 단위 변환
    if (distanceMeter > 1000) {
      // km
      distanceMeter /= 1000;
      if (distanceMeter < 10) {
        // 10km 미만이면 소수점 한 자리
        result = "${distanceMeter.toStringAsFixed(1)}km";
      } else {
        // 10km 이상이면 소수점 제거
        result = "${distanceMeter.toStringAsFixed(0)}km";
      }
    } else {
      // m
      result = "${distanceMeter.toStringAsFixed(0)}m";
    }
    return result;
  }
}
