import 'package:flutter/material.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:dongpo_test/api_key.dart';
import 'dart:developer';

void main() async {
  await _initialize();
  runApp(const NaverMapApp());
}

// 지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: naverApiKey, // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
}
