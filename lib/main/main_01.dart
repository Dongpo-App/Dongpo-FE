import 'dart:async';
import 'dart:developer';
import '/api_key.dart';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  await _initialize();
  runApp(const NaverMapApp());
}

// 지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: naverApiKey,     // 클라이언트 ID 설정
    onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed")
  );
}

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({Key? key});

  @override
  Widget build(BuildContext context) {
    // NaverMapController 객체의 비동기 작업 완료를 나타내는 Completer 생성
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            NaverMap(
              options: const NaverMapViewOptions(
                indoorEnable: true,             // 실내 맵 사용 가능 여부 설정
                locationButtonEnable: false,    // 위치 버튼 표시 여부 설정
                consumeSymbolTapEvents: false,  // 심볼 탭 이벤트 소비 여부 설정
              ),
              onMapReady: (controller) async {                // 지도 준비 완료 시 호출되는 콜백 함수
                mapControllerCompleter.complete(controller);  // Completer에 지도 컨트롤러 완료 신호 전송
                log("onMapReady", name: "onMapReady");
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '메인',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: '등록',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: '커뮤니티',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: '마이페이지',
                  ),
                ],
                currentIndex: 0,
                selectedItemColor: Colors.red,
                onTap: (int index) {
                  // 하단 메뉴바 클릭 시 동작
                  // 여기에 클릭 시 수행할 동작을 작성합니다.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
