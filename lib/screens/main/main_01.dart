import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:dongpo_test/api_key.dart';
import 'package:dongpo_test/widgets/main/map.dart';
import 'package:geolocator/geolocator.dart';

// 지도 초기화하기
Future<void> reset_map() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: naverApiKey, // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMapApp(),
      // FutureBuilder<String>(
      //     future: checkPermission(),
      //     builder: (context, snapshot) {
      //       //1.로딩 상태
      //       if (!snapshot.hasData &&
      //           snapshot.connectionState == ConnectionState.waiting) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       //2. 권한 허가상태
      //       if (snapshot.data == "위치 권한이 허가 되었습니다.") {
      //         return NaverMapApp();
      //       }
      //       return Center(
      //         child: Text(snapshot.data.toString()),
      //       );
      //     })
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled =
        await Geolocator.isLocationServiceEnabled(); // 위치 서비스 활성화여부 확인

    if (!isLocationEnabled) {
      // 위치 서비스 활성화 안 됨
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission =
        await Geolocator.checkPermission(); // 위치 권한 확인

    if (checkedPermission == LocationPermission.denied) {
      // 위치 권한 거절됨

      // 위치 권한 요청하기
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    // 위치 권한 거절됨 (앱에서 재요청 불가)
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    // 위 모든 조건이 통과되면 위치 권한 허가완료
    return '위치 권한이 허가 되었습니다.';
  }
}
