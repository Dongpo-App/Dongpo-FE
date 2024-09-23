import 'package:dongpo_test/api_key.dart';
import 'package:dongpo_test/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const serverUrl = "https://ysw123.xyz";

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
      home: const LoginPage(), // 로그인 페이지 이동
    );
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