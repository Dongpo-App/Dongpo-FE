import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/widgets/buttonForm.dart';

class GageJungbo extends StatelessWidget {
  const GageJungbo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('가게 정보'),
              Text('A 님이 등록하셨어요.'),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.orange, borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('오픈 요일 '),
                    Spacer(),
                    Text('data'),
                  ],
                ),
                Row(
                  children: [
                    Text('오픈 시간 '),
                    Spacer(),
                    Text('data'),
                  ],
                ),
                Row(
                  children: [Text('결제 방식 '), Spacer(), Text('data')],
                ),
                Row(
                  children: [Text('화장실 '), Spacer(), Text("data")],
                ),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('가게 정보 수정하기'))
        ],
      ),
    );
  }
}
