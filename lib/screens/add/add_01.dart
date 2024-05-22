import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위치 제보'),
      ),
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              //초기 지도값
              initialCameraPosition: NCameraPosition(
                  target: NLatLng(37.49993604717163, 126.86768245932946),
                  zoom: 18),
              zoomGesturesEnable: false,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 180,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, //균등하게 배치
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 500,
                      height: 100,
                      child: Text(
                        "가게 위치를 알려주세요",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.only(left: 20),
                      color: Colors.grey,
                      child: Text(
                        '서울특별시 고척동 경인로 445',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 400,
                      child: ElevatedButton(
                        child: Text(
                          '가게 등록',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
