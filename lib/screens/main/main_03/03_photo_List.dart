import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPhoto extends StatelessWidget {
  MainPhoto({super.key});

  final List<Image> imageList = [
    const Image(image: AssetImage('assets/images/rakoon.png')),
    const Image(image: AssetImage('assets/images/rakoon.png')),
    const Image(image: AssetImage('assets/images/rakoon.png')),
    const Image(image: AssetImage('assets/images/rakoon.png')),
    const Image(image: AssetImage('assets/images/rakoon.png')),
    const Image(image: AssetImage('assets/images/rakoon.png')),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //사진 페이지로 이동해야함
      onTap: () => //Navigator.push,
          print('hi'),
      child: Container(
        height: 120,
        color: Colors.white,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 200,
              margin:
                  const EdgeInsets.fromLTRB(20, 0, 10, 10), // 이미지 사이의 간격을 조정
              child: imageList[index], // 이미지 리스트에서 이미지를 가져옴
            );
          },
        ),
      ),
    );
  }
}
