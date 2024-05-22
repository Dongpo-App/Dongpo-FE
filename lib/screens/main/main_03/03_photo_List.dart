import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPhoto extends StatelessWidget {
  MainPhoto({super.key});

  final List<Image> imageList = [
    Image(image: AssetImage('assets/images/rakoon.png')),
    Image(image: AssetImage('assets/images/rakoon.png')),
    Image(image: AssetImage('assets/images/rakoon.png')),
    Image(image: AssetImage('assets/images/rakoon.png')),
    Image(image: AssetImage('assets/images/rakoon.png')),
    Image(image: AssetImage('assets/images/rakoon.png')),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.amber,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(10), // 이미지 사이의 간격을 조정
            color: Colors.black,
            child: imageList[index], // 이미지 리스트에서 이미지를 가져옴
          );
        },
      ),
    );
  }
}
