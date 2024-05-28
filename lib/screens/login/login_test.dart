import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert'; // JSON 변환을 위해 import
import 'package:http/http.dart' as http; // HTTP 요청을 위해 import
import '../../main.dart';




void main() {
  runApp(MyLoginApp());
}

class MyLoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login Test',
      debugShowCheckedModeBanner: false, // 우측 상단 debug 표시 제거
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // redirect uri
  static const naverLoginRedirectURI = "com.example.dongpo_test";
  static const kakaoLoginRedirectURI = "com.example.dongpo_test";

  // 네이버 로그인 onTap
  Future<void> naverLogin() async {
    // 네이버 로그인 api 호출
    final url = Uri.parse(
        'https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=RONVWbHjr_XuPhPRuiGo&state=STATE_STRING&redirect_uri=$naverLoginRedirectURI'
    );

    // 네이버 로그인 후 callback 데이터 반환
    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: naverLoginRedirectURI);

    // token 데이터 파싱
    final accessToken = Uri.parse(result).queryParameters['accessToken'];
    final refreshToken = Uri.parse(result).queryParameters['refreshToken'];

    logger.d('naver - accessToken : ${accessToken}');
    logger.d('naver - refreshToken : ${refreshToken}');
  }

  // 카카오 로그인 onTap
  Future<void> kakaoLogin() async {
    // 카카오 로그인 api 호출
    final url = Uri.parse(
        'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=1e02d323a0ccbf930ce3e9d0e53bab22&redirect_uri=$kakaoLoginRedirectURI'
    );
    // 네이버 로그인 후 callback 데이터 반환
    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: kakaoLoginRedirectURI);

    // token 데이터 파싱
    final accessToken = Uri.parse(result).queryParameters['accessToken'];
    final refreshToken = Uri.parse(result).queryParameters['refreshToken'];

    logger.d('kakao - accessToken : ${accessToken}');
    logger.d('kakao - refreshToken : ${refreshToken}');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF33393F), // 바탕색 설정
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/login.png'),
            SizedBox(
              height: 40,
            ),
            Text(
              '동포',
              style: TextStyle(
                fontFamily: 'Chosun',
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () {
                  // 클릭 시 소셜로그인 url로 이동
                  naverLogin();
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF03C75A),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Image.asset(
                    'assets/images/login_naver.png',
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () {
                  // 클릭 시 소셜로그인 url로 이동
                  kakaoLogin();
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFFEE500),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Image.asset(
                    'assets/images/login_kakao.png',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

