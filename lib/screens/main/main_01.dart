import 'dart:developer';
import 'dart:async';
import 'package:dongpo_test/screens/main/main_02.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:dongpo_test/api_key.dart';
import 'package:dongpo_test/widgets/main/map.dart';
import 'package:geolocator/geolocator.dart';
import 'main_02.dart';

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
        body: FutureBuilder<String>(
            future: checkPermission(),
            builder: (context, snapshot) {
              //1.로딩 상태
              if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(snapshot.data);
              //2. 권한 허가상태
              if (snapshot.data == "위치 권한이 허가 되었습니다.") {
                return Stack(
                  children: [
                    NaverMapApp(), //지도 로딩
                    Positioned(
                      top: 65.0,
                      left: 16.0,
                      right: 16.0,
                      child: GestureDetector(
                        //tap 감지하기 위한 위젯
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return SearchPage();
                          }));
                        }, //주소 검색 페이지로 이동
                        onDoubleTap: () => print("두번 클릭됌"),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 8.0),
                              Text(
                                '내 주소 뜰곳 ( 로직 구현 .)',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[400]),
                              ),
                              SizedBox(width: 120.0),
                              Icon(Icons.search)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("인증을 실패했습니다")],
                ),
              );
            }));
  }

  Future<String> checkPermission() async {
    final isLocationEnabled =
        await Geolocator.isLocationServiceEnabled(); // 위치 서비스 활성화여부 확인

    if (!isLocationEnabled) {
      // 위치 서비스 활성화 안 됨
      log('위치 서비스 활성화 안됨');
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
