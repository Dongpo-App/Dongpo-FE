import 'package:dongpo_test/api_key.dart';
import 'package:dongpo_test/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dongpo_test/models/gaGeSangSe.dart';
import 'package:dongpo_test/models/pocha.dart';
import 'package:dongpo_test/screens/main/main_03/main_03.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'main_02.dart';
import 'package:dongpo_test/api_key.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:dongpo_test/screens/main/main_03/03_title.dart';
import 'package:dongpo_test/screens/main/main_03/02_photo_List.dart';
import 'package:dongpo_test/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dongpo_test/screens/add/add_01.dart';

const serverUrl = "https://ysw123.xyz";
const storage = FlutterSecureStorage();
//메인 함수
void main() async {
  // Flutter SDK 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // FlutterSecureStorage 초기화 및 토큰 삭제
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'accessToken');
  await storage.delete(key: 'refreshToken');
  await storage.delete(key: 'loginPlatform');

  // Kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: nativeAppKey,
  );

  // 스플래시 화면 초기화 및 유지
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await resetMap();
  // 앱 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '동포',
        debugShowCheckedModeBanner: false, // 우측 상단 debug 표시 제거
        theme: ThemeData(
          fontFamily: 'Pretendard',
          splashColor: Colors.transparent, // splash 효과 없애기
          highlightColor: Colors.transparent, // splash 효과 없애기
        ),
        home: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _testAPI();
                  },
                  child: Text('버튼'))
            ],
          ),
        ));
  }
}

void _testAPI() async {
  final accessToken = await storage.read(key: 'accessToken');
  logger.d("test함수 들어옴");
  final url = Uri.parse('$serverUrl/api/store/1');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);
  logger.d('$response');
  if (response.statusCode == 200) {
    logger.d('데이터 통신 성공 !! 상태코드 : ${response.statusCode}');
  } else {
    logger.e(
        'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : ${response.body}');
    throw Exception('HTTP ERROR !!! ${response.body}');
  }
}

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);


/* 
로거 사용법 

  logger.d('Log message with 2 methods');

  loggerNoStack.i('Info message');

  loggerNoStack.w('Just a warning!');

  logger.e('Error! Something bad happened', 'Test Error');

  loggerNoStack.v({'key': 5, 'value': 'something'});

  Logger(printer: SimplePrinter(colors: true)).v('boom');

*/