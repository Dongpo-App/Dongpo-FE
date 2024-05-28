import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dongpo_test/login_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert'; // JSON 변환을 위해 import
import 'package:http/http.dart' as http; // HTTP 요청을 위해 import

import '../../main.dart';
import 'package:dongpo_test/models/login_data.dart';


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
  Map<String, dynamic> _user = {};

  // 네이버 로그인 onTap https://dongpo-api-server.xyz/auth/naver/callback
  Future<void> naverLogin(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      final redirectUri = await _getRedirectUri();
      final code = _extractCodeFromUri(redirectUri);
      final tokens = await _exchangeCodeForTokens(code);
      // _saveLoginInfo(tokens['accessToken'], tokens['refreshToken']);
    } else {
      throw 'Could not launch Naver login URL';
    }
  }

  Future<String> _getRedirectUri() async {
    // 사용자가 네이버 로그인을 완료하면 리디렉션된 URI를 가져오는 코드
    // 이 예시에서는 단순히 'https://example.com/callback'을 반환합니다.
    return 'https://dongpo-api-server.xyz/auth/naver/callback';
  }

  String _extractCodeFromUri(String uri) {
    // 리디렉션된 URI에서 인증 코드를 추출하는 코드
    // 이 예시에서는 단순히 'CODE_STRING'을 반환합니다.
    return 'CODE_STRING';
  }

  Future<Map<String, String>> _exchangeCodeForTokens(String code) async {
    // 인증 코드를 사용하여 액세스 토큰과 리프레시 토큰을 요청하는 코드
    // 이 예시에서는 단순히 샘플 토큰 값을 반환합니다.
    return {
      'accessToken': 'SAMPLE_ACCESS_TOKEN',
      'refreshToken': 'SAMPLE_REFRESH_TOKEN',
    };
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
              padding: EdgeInsets.all(24),
              child: InkWell(
                onTap: () {
                  // 클릭 시 소셜로그인 url로 이동
                  naverLogin(naverLoginUrl);
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF03C75A),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/login_naver.png',
                      ),
                      Text(
                        '네이버로 시작하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

