import 'package:flutter/material.dart';
import 'package:dongpo_test/widgets/bottom_navigation_bar.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  await reset_map();
  await Geolocator.requestPermission();
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
      home: const MyAppPage(), // main_01.dart
    );
  }
}
