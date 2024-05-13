import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});
  @override
  State<NaverMapApp> createState() => NaverMapAppState();
}

class NaverMapAppState extends State<NaverMapApp> {
  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              indoorEnable: true, // 실내 맵 사용 가능 여부 설정
              locationButtonEnable: true, // 위치 버튼 표시 여부 설정
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
              // 지도 준비 완료 시 호출되는 콜백 함수
              mapControllerCompleter
                  .complete(controller); // Completer에 지도 컨트롤러 완료 신호 전송
              log("onMapReady", name: "onMapReady");
              final NLatLng test =
                  NLatLng(37.49993604717163, 126.86768245932946); //테스트 위도 경도
              final NMarker marker =
                  NMarker(id: "test_Maker", position: test); //테스트 마커
              //마커 표시
              controller.addOverlay(marker);
              final onMarkerInfoWindow =
                  NInfoWindow.onMarker(id: marker.info.id, text: "동미대");
              marker.openInfoWindow(onMarkerInfoWindow);
            },
          ),
        ],
      ),
    );
  }
}
