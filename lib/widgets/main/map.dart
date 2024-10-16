import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:developer';

class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});
  @override
  State<NaverMapApp> createState() => NaverMapAppState();
}

class NaverMapAppState extends State<NaverMapApp> {
  late NaverMapController _mapController;
  final String _currentAddress = "";

  @override
  Widget build(BuildContext context) {
    List<NLatLng> NList = [
      const NLatLng(37.49993604717163, 126.86768245932946),
      const NLatLng(37.49993604717164, 126.86768245932941),
      const NLatLng(37.49993604717165, 126.86768245932942),
      const NLatLng(37.49993604717166, 126.86768245932943),
      const NLatLng(37.49993604717167, 126.86768245932944),
      const NLatLng(37.49993604717168, 126.86768245932945),
      const NLatLng(37.49993604717169, 126.86768245932946),
    ];

    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              indoorEnable: true, // 실내 맵 사용 가능 여부 설정
              locationButtonEnable: false, // 위치 버튼 표시 여부 설정
              minZoom: 16, //쵀대 줄일 수 있는 크기?
              maxZoom: 18, //최대 당길 수 있는 크기
              initialCameraPosition: NCameraPosition(
                //첫 로딩시 카메라 포지션 지정
                target: NLatLng(37.49993604717163, 126.86768245932946),
                zoom: 16, bearing: 0,
                tilt: 0,
              ),
              extent: NLatLngBounds(
                //지도 영역을 한반도 인근으로 제한
                southWest: NLatLng(31.43, 122.37),
                northEast: NLatLng(44.35, 132.0),
              ),
            ),
            onMapReady: (controller) async {
              log("onMapReady", name: "onMapReady");
              const NLatLng test =
                  NLatLng(37.49993604717163, 126.86768245932946); //테스트 위도 경도

              final NMarker marker = NMarker(
                id: "test_Maker",
                position: test,
              ); //테스트 마커
              //커스텀 마커 생성
              var customMarker = const NOverlayImage.fromAssetImage(
                  "assets/images/rakoon.png");
              //마커 아이콘 변경
              marker.setIcon(customMarker);
              //마커 크기 조절
              var defaultMarkerSize = const Size(40, 50);
              marker.setSize(defaultMarkerSize);

              marker.setOnTapListener((overlay) => print("마커눌렸다"));
              //마커 표시
              controller.addOverlay(marker);
            },
          ),
        ],
      ),
    );
  }
}
