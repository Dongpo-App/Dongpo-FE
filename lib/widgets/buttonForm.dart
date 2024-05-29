//표준 스타일 정리
import 'package:flutter/material.dart';

/* 버튼 사용하는 방식 
사이즈 화면에 맞춰서 가로로 최대로.
화면을 구성하는 큰 Container 에 Padding을 주어서 사이즈를 줄임 
*/

ElevatedButton _standardBtn() {
  return ElevatedButton(
    onPressed: () {
      //버튼 등록 로직
    },
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      backgroundColor: Color(0xffF15A2B),
    ),
    child: Text(
      "버튼 텍스트",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}

ButtonStyle _btnStyle() {
  return ButtonStyle(
    // 버튼의 가로 크기를 최대로 설정
    minimumSize: MaterialStateProperty.all(Size.fromWidth(double.infinity)),
    // 테두리 모서리를 둥글게 설정
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );
}

//  Color(0xffF15A2B), // 주황색
// Color(0xff767676), 회색
ButtonStyle btnSty = _btnStyle();
