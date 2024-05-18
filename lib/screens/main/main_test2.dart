import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dongpo_test/api_key.dart';
import 'dart:developer';
import 'dart:async';

// 지도 초기화하기
Future<void> reset_map() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: naverApiKey, // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
}

void main() async {
  await reset_map();
  runApp(MyApp());
}

void getLocation() async {
  Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print(position);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Example',
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            NaverMap(),
            Positioned(
              bottom: 90.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  getLocation();
                },
                child: Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    NaverMap(
      onMapReady: (controller) {
        NLatLng nowPosition = NLatLng(position.latitude, position.longitude);
        final update = NCameraUpdate.withParams(
          target: nowPosition,
          zoomBy: -2,
          bearing: 180,
        );
        controller.updateCamera(update);
        controller.getCameraPosition();
        NaverMapController
      },
    );
  }
}
