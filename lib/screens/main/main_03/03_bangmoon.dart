import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BangMoon extends StatelessWidget {
  const BangMoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "방문에 성공하셨나요?",
          style: TextStyle(fontSize: 30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 200,
              child: Row(children: [
                Icon(Icons.tag_faces_outlined),
                SizedBox(width: 10),
                Text("방문 성공 A명 "),
              ]),
            ),
            Container(
              height: 50,
              width: 200,
              child: Row(children: [
                Icon(Icons.tag_faces_outlined),
                SizedBox(
                  width: 10,
                ),
                Text("방문 성공 A명 "),
              ]),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                //방문 인증 페이지로 이동 구현해야함
              },
              child: Text(
                "방문 인증 하러 가기",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Color(0xffF15A2B)),
              ),
            )
          ],
        )
      ],
    );
  }
}
