//단골손님 표시

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DanGolGuest extends StatelessWidget {
  const DanGolGuest({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이 가게 단골 손님',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xff767676),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/rakoon.png"),
                radius: 27,
              ),
              Column(
                children: [Text("실패는 성공의 어머니"), Text("도도한 고양이")],
              )
            ],
          ),
        ),
      ],
    );
  }
}

//  Color(0xffF15A2B), // 주황색
// Color(0xff767676), 회색
