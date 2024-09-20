//가게정보 자세히
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:dongpo_test/screens/main/main_03/03_bangmoon.dart';
import 'package:dongpo_test/screens/main/main_03/03_gagejungbo.dart';
import 'package:dongpo_test/screens/main/main_03/03_photo_List.dart';
import 'package:dongpo_test/screens/main/main_03/03_review.dart';
import 'package:dongpo_test/screens/main/main_03/03_title.dart';
import 'package:dongpo_test/screens/main/main_03/03_user_action.dart';
import 'package:dongpo_test/screens/main/main_03/03_dangol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StoreInfo(),
    );
  }
}

//가게정보 상세 페이지

class StoreInfo extends StatefulWidget {
  const StoreInfo({super.key});

  @override
  State<StoreInfo> createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  //라디오 버튼 관련 변수
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //앱바 뒤로가기, 신고하기
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   onPressed: () {
        //     //뒤로가기 기능 구현
        //   },
        //   icon: Icon(Icons.arrow_back_ios_new),
        // ),
        actions: [
          IconButton(
            onPressed: () {
              //신고 기능 구현
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        margin: const EdgeInsets.all(25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "가게에 문제가 있나요?",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      setState(() => value = 0);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(CupertinoIcons.xmark))
                              ],
                            ),
                            const Text(
                              "항목에 알맞게 선택해주세요.",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _radioBtn('없어진 가게에요', 1, setState),
                                  _radioBtn('위치가 틀려요', 2, setState),
                                  _radioBtn('부적절한 정보가 포함되어 있어요', 3, setState),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  (value == 0) ? null : print('버튼 활성화');
                                  //dio.post()구현
                                },
                                style: ElevatedButton.styleFrom(
                                  splashFactory: (value == 0) // 아무것도 터치 안했으면
                                      ? NoSplash.splashFactory //스플레시 효과 비활성화
                                      : InkSplash.splashFactory, //스플레시 효과 활성화
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  minimumSize: const Size(double.infinity, 40),
                                  backgroundColor: value != 0
                                      ? const Color(0xffF15A2B)
                                      : Colors.grey[300],
                                ),
                                child: Text(
                                  "가게 신고",
                                  style: TextStyle(
                                      color: (value > 0)
                                          ? Colors.white
                                          : Colors.grey[600]),
                                )),
                          ],
                        ),
                      );
                    });
                  });
            },
            icon: const Icon(
              Icons.warning_rounded,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            //제목, 영업가능성, 거리
            const MainTitle(),
            //사진
            const SizedBox(
              height: 30,
            ),
            MainPhoto(),
            const SizedBox(
              height: 20,
            ),
            //리뷰 갯수, 버튼
            const UserAction(),
            const SizedBox(
              height: 30,
            ),
            //방문인증
            const BangMoon(),
            const SizedBox(
              height: 40,
            ),
            //리뷰 관련
            const ShowReview(),
            const SizedBox(
              height: 80,
            ),
            //가게정보
            const GageJungbo(),
            const SizedBox(
              height: 80,
            ),
            //이 가게 단골 손님
            const DanGolGuest(),
          ],
        ),
      ),
    );
  }

  Widget _radioBtn(String text, int index, StateSetter setStater) {
    return ElevatedButton(
      onPressed: () {
        setStater(() {
          value = index;
          print('$index');
        });
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        minimumSize: const Size(double.infinity, 40),
        backgroundColor:
            (value == index) ? const Color(0xffF15A2B) : Colors.grey[300],
      ),
      child: Text(
        text,
        style: TextStyle(
            color: (value == index) ? Colors.white : Colors.grey[600]),
      ),
    );
  }
}

//기본색깔 0xffF15A2B
//MediaQuery.of(context).size.height
