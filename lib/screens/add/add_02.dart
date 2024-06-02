import 'package:dongpo_test/widgets/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class GageAddSangsea extends StatefulWidget {
  const GageAddSangsea({super.key});

  @override
  State<GageAddSangsea> createState() => _GageAddSangseaState();
}

class _GageAddSangseaState extends State<GageAddSangsea> {
  String openTime = '00:00';
  String closeTime = '00:00';
  int bathSelected = 0; //화장실 라디오 버튼

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '가게 등록',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyAppPage();
                }));
              },
              icon: Icon(CupertinoIcons.xmark))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: ListView(
          children: [
            //가게 위치 *
            Row(
              children: [
                Text(
                  '가게 위치',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '*',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            //가게위치 검색바
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //검색바 안에 주소
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    Text(
                      'A (주소 띄우기)',
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                    ),
                    Spacer(),
                    Icon(CupertinoIcons.right_chevron),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //가게 이름 *
            Row(
              children: [
                Text(
                  '가게 이름',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '*',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                left: 16,
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '가게 이름을 입력해주세요.',
                  border: InputBorder.none, // 밑줄 제거
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),

            // 오픈 요일
            Row(
              children: [
                Text(
                  '오픈요일',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '여러 개 선택 가능해요!',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),

            // 오픈시간
            Row(
              children: [
                Text(
                  '오픈 시간',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),

            //오픈시간 시간설정
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        picker.DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            openTime = "${date.hour}:${date.minute}";
                          });
                        }, currentTime: DateTime.now());
                      },
                      //openTime Container
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          '$openTime',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    " ~ ",
                    style: TextStyle(fontSize: 25),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        picker.DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            closeTime = "${date.hour}:${date.minute}";
                          });
                        }, currentTime: DateTime.now());
                      },
                      //closeTime Container
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          '$closeTime',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),

            //결제 방식
            Row(
              children: [
                Text(
                  '결제 방식',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '여러 개 선택 가능해요!',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),

            SizedBox(
              height: 30,
            ),
            //화장실
            Row(
              children: [
                Text(
                  '화장실',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: _bathSelected('있음', 1)),
                SizedBox(width: 30),
                Expanded(child: _bathSelected('없음 ', 2)),
              ],
            ),
            //가게 등록버튼

            SizedBox(
              height: 30,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  //모두 동의했을 경우 버튼 활성화
                  backgroundColor:
                      1 == 1 ? Color(0xffF15A2B) : Colors.grey[300],
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                //가게 등록 로직 구현
              },
              child: Text(
                '가게등록',
                style:
                    TextStyle(color: 1 == 1 ? Colors.white : Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //화장실 라디오버튼
  Widget _bathSelected(String text, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor:
              bathSelected == index ? Color(0xffF15A2B) : Colors.grey[300]),
      onPressed: () {
        setState(() {
          bathSelected = index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
            color: bathSelected == index ? Colors.white : Colors.grey[700]),
      ),
    );
  }
}
