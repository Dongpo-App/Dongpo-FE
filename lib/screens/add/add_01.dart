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
      body: NaverMap(
        options: NaverMapViewOptions(
          //초기 지도값
          initialCameraPosition: NCameraPosition(
              target: NLatLng(37.49993604717163, 126.86768245932946), zoom: 18),
          minZoom: 18,
          maxZoom: 18,
        ),
      ),
    );
  }
}
