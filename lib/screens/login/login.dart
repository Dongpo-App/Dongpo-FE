import 'package:dongpo_test/models/login_status_enum.dart';
import 'package:dongpo_test/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/widgets/bottom_navigation_bar.dart';
import 'apple_user_info_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginApiService loginService = LoginApiService.instance;

  // Future<void> loginsfa() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF33393F), // 바탕색 설정
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/login.png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Text(
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
            // 소셜 로그인 - 애플
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () async {
                  LoginStatus status = await loginService.appleLogin();
                  if (status == LoginStatus.success) {
                    if (mounted) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyAppPage()));
                    }
                  } else if (status == LoginStatus.duplicateEmail) {
                    httpStatusCode409();
                  }
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12.0), // 이미지가 컨테이너 경계를 넘지 않도록 둥근 모서리 설정
                    child: Image.asset(
                      'assets/images/login_apple.png',
                      fit: BoxFit.contain, // 이미지가 컨테이너에 맞게 조정되도록 설정
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 소셜 로그인 - 네이버
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () async {
                  LoginStatus status = await loginService.naverLogin();
                  if (status == LoginStatus.success) {
                    if (mounted) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyAppPage()));
                    }
                  } else if (status == LoginStatus.duplicateEmail) {
                    httpStatusCode409();
                  }
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF03C75A),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12.0), // 이미지가 컨테이너 경계를 넘지 않도록 둥근 모서리 설정
                    child: Image.asset(
                      'assets/images/login_naver.png',
                      fit: BoxFit.contain, // 이미지가 컨테이너에 맞게 조정되도록 설정
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 소셜 로그인 - 카카오
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () async {
                  LoginStatus status = await loginService.kakaoLogin();
                  if (status == LoginStatus.success) {
                    if (mounted) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyAppPage()));
                    }
                  } else if (status == LoginStatus.duplicateEmail) {
                    httpStatusCode409();
                  }
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE500),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12.0), // 이미지가 컨테이너 경계를 넘지 않도록 둥근 모서리 설정
                    child: Image.asset(
                      'assets/images/login_kakao.png',
                      fit: BoxFit.contain, // 이미지가 컨테이너에 맞게 조정되도록 설정
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const AppleUserInfoPage()),
                  );
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12.0), // 이미지가 컨테이너 경계를 넘지 않도록 둥근 모서리 설정
                    child: const Text(
                      "애플로그인 정보 입력 페이지",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void httpStatusCode409() {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "로그인 실패",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "이미 등록된 이메일이에요",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Center(child: okButton),
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
