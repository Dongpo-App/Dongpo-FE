import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/login/login.dart';
import 'package:dongpo_test/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    const String topImage = "assets/images/login.png";
    const String spalshImage = "assets/images/splash_page.png";
    //const String iconImage = "assets/images/icon.png";

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF33393F),
      body: SizedBox(
        width: screenWidth,
        child: Image.asset(
          spalshImage,
          fit: BoxFit.cover,
        ),
      ),
      // 추후에 사진의 위 부분을 자른 후 사용
      //Column(
      //   children: [
      //     Image.asset(topImage),
      //     SizedBox(
      //       height: screenHeight * 0.3,
      //     ),
      //     const Text(
      //       "동포",
      //       style: TextStyle(
      //         color: Color(0xffffffff),
      //         fontSize: 60,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Future<bool> _validRefreshToken() async {
    logger.d("_validRefreshToken() 진입");
    // 리프레쉬 토큰 유무 확인
    String? refreshToken = await storage.read(key: 'refreshToken');
    if (refreshToken == null) return false; // 토큰 없음 -> 로그인 화면

    final url = Uri.parse('$serverUrl/auth/reissue');
    final header = {'Content-Type': 'application/json'};
    final body = jsonEncode({'refreshToken': refreshToken});

    // 토큰 재발급
    try {
      final response = await http.post(url, headers: header, body: body);
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        logger.d("reissue success : ${response.statusCode}");

        Map<String, dynamic> tokens = decodedResponse['data'];
        logger.d("message : ${decodedResponse['message']}");

        // 토큰 저장
        await storage.write(key: 'accessToken', value: tokens['accessToken']);
        await storage.write(key: 'refreshToken', value: tokens['refreshToken']);

        // 데이터 확인
        //Map<String, String> allData = await storage.readAll();
        //logger.d("secure storage check data : $allData");

        return true;
      } else if (response.statusCode == 401) {
        logger.w(
            "code : ${response.statusCode} Invalid token. Redirecting to login page.");
        logger.w("message : ${decodedResponse['message']}");
        // 만료된 토큰 삭제
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'refreshToken');
        await storage.delete(key: 'loginPlatform');
        return false;
      } else {
        logger.w("Fail to reissue token : ${response.statusCode}");
        logger.w("message : ${decodedResponse['message']}");
        return false;
      }
    } catch (error) {
      logger.e("Error! : ${error.toString()}");
      return false;
    }
  }

  Future<void> _showPage() async {
    bool isTokenValid = await _validRefreshToken();
    await Future.delayed(const Duration(milliseconds: 1200));
    logger.d("isTokenValid result : $isTokenValid");
    if (isTokenValid) {
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyAppPage()));
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }
}
