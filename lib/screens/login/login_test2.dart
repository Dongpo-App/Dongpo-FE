import 'package:dongpo_test/screens/login/kakao_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../main.dart';
import 'login_view_model.dart';


void main() {
  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '24cd6ed6d20dc17c90517c9efde8254b',
  );
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
  final loginViewModel = LoginViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF33393F), // 바탕색 설정
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/login.png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Text(
              '동포 시작하기',
              style: TextStyle(
                fontFamily: 'Chosun',
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            // 소셜 로그인 - 네이버
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () {
                  // naverLogin();
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
            // 소셜 로그인 - 카카오
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () async {
                  await loginViewModel.kakaoLogin();
                  setState(() {
                    // 로그인 후 단순 화면 갱신
                  });
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
            SizedBox(height: 24),
            // 로그아웃
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () async {
                  await loginViewModel.logout();
                  setState(() {
                     // 로그아웃 후 단순 화면 갱신
                  });
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF15A2B),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'login test : ${loginViewModel.isLogined}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}