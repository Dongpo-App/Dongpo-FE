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
        Row(),
        ElevatedButton(onPressed: () {}, child: Text("yes")),
        ElevatedButton(onPressed: () {}, child: Text("no")),
      ],
    );
  }
}
