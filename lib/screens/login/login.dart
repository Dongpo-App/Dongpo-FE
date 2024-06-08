import 'package:dongpo_test/screens/login/kakao_naver_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dongpo_test/api_key.dart';
import 'package:dongpo_test/widgets/bottom_navigation_bar.dart';
import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'login_view_model.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginViewModel = LoginViewModel(KakaoNaverLogin());

  // FlutterSecureStorage
  static final storage = new FlutterSecureStorage(); //flutter_secure_storage 초기화 작업
  Map<String, String>? _allData; // secure storage 데이터 확인용

  @override
  void initState(){
    super.initState();
    //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAuthToken();
    });
  }
  Future<void> _loadAuthToken() async {
    // key값에 맞는 데이터 값 불러옴 데이터가 없을 때는 null을 반환
    final accessToken = await storage.read(key: 'accessToken');
    final refreshToken = await storage.read(key: 'refreshToken');
    Map<String, String> allData = await storage.readAll();
    // token 데이터가 있다면 메인페이지로 이동
    if (accessToken != null && refreshToken != null){
      logger.d("secure storage read 1 : ${allData}");
      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              MyAppPage()
      ));
    }
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
                onTap: () async {
                  await loginViewModel.naverLogin();
                  // 서버에서 발급받은 토큰을 FlutterSecureStorage에 저장
                  await storage.write(key: 'accessToken', value: loginViewModel.accessToken);
                  await storage.write(key: 'refreshToken', value: loginViewModel.refreshToken);
                  Map<String, String> allData = await storage.readAll();
                  logger.d("secure storage naver read : ${allData}");
                  setState(() {
                    // 로그인 후 단순 화면 갱신
                  });
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
                  // 서버에서 발급받은 토큰을 FlutterSecureStorage에 저장
                  await storage.write(key: 'accessToken', value: loginViewModel.accessToken);
                  await storage.write(key: 'refreshToken', value: loginViewModel.refreshToken);
                  Map<String, String> allData = await storage.readAll();
                  logger.d("secure storage kakao read : ${allData}");
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
                  // FlutterSecureStorage에 있는 token 삭제
                  await storage.delete(key: 'accessToken');
                  await storage.delete(key: 'refreshToken');
                  Map<String, String> allData = await storage.readAll();
                  logger.d("secure storage delete read : ${allData}");
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
              '${loginViewModel.loginPlatform.name} login test : ${loginViewModel.isLogined}',
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