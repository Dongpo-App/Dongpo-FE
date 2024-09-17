//단골손님 표시

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DanGolGuest extends StatelessWidget {
  const DanGolGuest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/rakoon.png"),
            radius: 27,
          ),
          Column(
            children: [Text('data'), Text('data')],
          ),
        ],
      ),
    );
  }
}

//  Color(0xffF15A2B), // 주황색
// Color(0xff767676), 회색
