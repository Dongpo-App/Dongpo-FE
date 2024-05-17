import 'package:flutter/material.dart';
import 'package:dongpo_test/widgets/main/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NaverMapApp(),
          Positioned(
            top: 40.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '서울특별시 고척동 경인로 445',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 90.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                // 내 위치 버튼 클릭 시 실행할 코드
              },
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
