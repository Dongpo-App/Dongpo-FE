import 'package:dongpo_test/api_key.dart';
import 'package:dongpo_test/screens/login/splash_page.dart';
import 'package:dongpo_test/screens/main/main_03/main_03.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';

const serverUrl = "https://ysw123.xyz";

//메인 함수
void main() async {
  // Flutter SDK 초기화 보장
  // 스플래시 화면 초기화 및 유지
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: nativeAppKey,
  );

  // 지도 초기화
  await NaverMapSdk.instance.initialize(
    clientId: naverApiKey, // 클라이언트 ID 설정
    onAuthFailed: (e) => logger.e("네이버맵 인증오류 : $e onAuthFailed"),
  );
  FlutterNativeSplash.remove();

  // 앱 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '동포',
      // CupertinoDatePicker 한글화
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // Korean
        Locale('en', 'US'), // English
      ],
      // 우측 상단 debug 표시 제거
      debugShowCheckedModeBanner: false,
      // splash 효과 없애기
      theme: ThemeData(
        fontFamily: 'Pretendard', // 기본 폰트
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const SplashPage(), // 로그인 페이지 이동
      onGenerateRoute: (settings) {
        if (settings.name == '/storeInfo') {
          // 전달된 arguments를 int로 캐스팅
          final index = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              // idx 값을 포함하여 StoreInfo 페이지 생성
              return StoreInfo(idx: index);
            },
          );
        }
        return null; // 설정되지 않은 경로는 null 반환
      },
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