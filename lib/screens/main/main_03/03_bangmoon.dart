import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class BangMoon extends StatelessWidget {
  const BangMoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '방문에 성공하셨나요?',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //방문 성공 컨테이너
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: [
                Icon(color: Colors.green[700], Icons.sentiment_satisfied_alt),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '방문 성공 A명',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
          //방문 실패 컨테이너
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            decoration: BoxDecoration(
                color: Colors.red[200],
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: [
                Icon(
                  color: Colors.red[800],
                  Icons.sentiment_dissatisfied_outlined,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('방문 실패 A명', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ],
      ),
      Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SecondPage()));
          },
          child: Text(
            '방문 인증 하러가기',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            minimumSize: Size(double.infinity, 40),
            backgroundColor: Color(0xffF15A2B),
          ),
        ),
      )
    ]);
  }
}

// 방문 인증 페이지
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('가게 방문 인증 '),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: NaverMap(
                //현재 내위치와
                //내 위치 마커하나 생성
                //지도 못움직이게 설정
                ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 23,
                      ),
                      Text(
                        '가게 방문 인증',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //방문 성공 컨테이너
                      Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          children: [
                            Icon(
                                color: Colors.green[700],
                                Icons.sentiment_satisfied_alt),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '방문 성공 A명',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                      ),
                      //방문 실패 컨테이너
                      Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        decoration: BoxDecoration(
                            color: Colors.red[200],
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          children: [
                            Icon(
                              color: Colors.red[800],
                              Icons.sentiment_dissatisfied_outlined,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('방문 실패 A명',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        //방문 인증 메서드 구현
                      },
                      child: Text(
                        '방문인증',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        minimumSize: Size(double.infinity, 40),
                        backgroundColor: Color(0xffF15A2B),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
