//가게정보 자세히
import 'package:dongpo_test/screens/main/main_03/03_bangmoon.dart';
import 'package:dongpo_test/screens/main/main_03/03_gagejungbo.dart';
import 'package:dongpo_test/screens/main/main_03/03_photo_List.dart';
import 'package:dongpo_test/screens/main/main_03/03_review.dart';
import 'package:dongpo_test/screens/main/main_03/03_title.dart';
import 'package:dongpo_test/screens/main/main_03/03_user_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreInfo(),
    );
  }
}

class StoreInfo extends StatelessWidget {
  const StoreInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //앱바 뒤로가기, 신고하기
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            //뒤로가기 기능 구현
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //신고 기능 구현
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                        height: 400,
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "가게에 문제가 있나요?",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.cancel_outlined))
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "항목에 알맞게 선택해 주세요",
                                style: TextStyle(fontSize: 30),
                              ),
                              OutlinedButton(
                                  onPressed: () {}, child: Text('a')),
                              OutlinedButton(
                                  onPressed: () {}, child: Text('a')),
                              OutlinedButton(
                                  onPressed: () {}, child: Text('a')),
                              OutlinedButton(
                                  onPressed: () {}, child: Text('신고')),
                            ],
                          ),
                        ));
                  });
            },
            icon: Icon(
              Icons.warning_amber_sharp,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          //제목, 영업가능성, 거리
          MainTitle(),
          //사진
          MainPhoto(),
          //리뷰 갯수, 버튼
          UserAction(),
          SizedBox(
            height: 40,
          ),
          //방문인증
          BangMoon(),
          SizedBox(
            height: 40,
          ),
          //리뷰 관련
          ShowReview(),
          SizedBox(
            height: 150,
          ),
          //가게정보
          GageJungbo(),
          //이 가게 단골 손님

          //DangolGeast(),
        ],
      ),
    );
  }
}

//기본색깔 0xffF15A2B
