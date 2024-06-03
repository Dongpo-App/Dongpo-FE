import 'package:dongpo_test/screens/main/main_03/main_03.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'main_02.dart';
import 'package:dongpo_test/api_key.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'main_01.dart';

Future<void> reset_map() async {
  // splash 화면 종료

  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: naverApiKey, // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
}

void main() async {
  await reset_map();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // 애니메이션 컨트롤러 선언
  late Animation<Offset> _offsetAnimation; // 슬라이더 애니메이션 선언
  late Animation<double> _buttonAnimation; // 버튼 애니메이션 선언
  late Animation<double> _locationBtn;
  late NaverMapController _mapController;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화 (300ms 동안 애니메이션 실행)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // 슬라이더 애니메이션 설정 (화면의 60% 지점에서 시작하여 원래 위치로)
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // 버튼 애니메이션 설정 (초기 위치는 100, 최종 위치는 300)
    _buttonAnimation = Tween<double>(
      begin: 45.0,
      end: 165.0, // 100 + 200 (컨테이너 높이)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _locationBtn = Tween<double>(
      begin: 85.0,
      end: 210.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

  // 슬라이더 토글 함수
  void _toggleBottomSheet() {
    setState(() {
      if (_controller.isDismissed) {
        _controller.forward(); // 애니메이션 시작
      } else {
        _controller.reverse(); // 애니메이션 되돌리기
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Application'), // 앱바 타이틀 설정
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blueAccent, // 지도 배경 예제
            child: NaverMap(onMapReady: (controller) async {
              _onMapReady(controller);
              log("onMapReady", name: "onMapReady");
            }),
          ),
          // 슬라이더 컨테이너
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _offsetAnimation, // 슬라이더 애니메이션 적용
              child: Container(
                padding: EdgeInsets.all(25),
                height: 200, // 튀어나오는 부분을 포함한 전체 높이
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A (구로구 고척동)',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        height: 70,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (BuildContext ctx, int idx) {
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return StoreInfo();
                                      }));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.grey[300],
                                      height: 80,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/rakoon.png'),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('A(고척 포장마차 1)'),
                                              Row(
                                                children: [
                                                  Icon(Icons
                                                      .location_on_rounded),
                                                  Text('A 영업 가능성 높아요!')
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  )
                                ],
                              );
                            }),
                      ),
                    ]),
              ),
            ),
          ),
          //
          // 왼쪽 하단 위치 재검색 버튼
          AnimatedBuilder(
              animation: _locationBtn,
              builder: (context, child) {
                return Positioned(
                  bottom: _locationBtn.value,
                  left: 16.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        iconColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white)),
                    onPressed: _moveToCurrentLocation,
                    child: Icon(Icons.my_location),
                  ),
                );
              }),

          // 슬라이더와 함께 올라오는 버튼
          AnimatedBuilder(
            animation: _buttonAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: _buttonAnimation.value, // 애니메이션 값에 따라 위치 설정
                left: 0,
                right: 0,
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        _toggleBottomSheet();
                        //현재 위치 위도경도 기준으로해서 리스트 받아온거 기본정보 띄우는 함수 만들어야함
                        //ex)) 게시판의 제목
                      },
                      icon: Icon(Icons.menu)),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        // height: bottomNavHeight,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account),
              label: '',
            ),
          ],
          iconSize: 24,

          selectedItemColor: const Color(0xffF15A2B), // 클릭 시 변경할 색상
          unselectedItemColor: const Color(0xff767676), // 클릭되지 않은 아이콘 색상

          type: BottomNavigationBarType.fixed, // 메뉴 아이템 고정 크기
          showSelectedLabels: false, // 라벨 감추기
          showUnselectedLabels: false, // 라벨 감추기
          enableFeedback: false, // 선택 시 효과음 X
        ),
      ),
    );
  }

  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
  }

  Future<void> _moveToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapController.updateCamera(
      NCameraUpdate.fromCameraPosition(
        NCameraPosition(
          target: NLatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
      ),
    );
  }
}


                //위치 재검색 버튼
                // AnimatedPositioned(
                //   duration: Duration(milliseconds: 300),
                //   top: _showReSearchButton ? 110.0 : -40.0,
                //   left: MediaQuery.of(context).size.width / 4,
                //   right: MediaQuery.of(context).size.width / 4,
                //   child: GestureDetector(
                //     onTap: () async {
                //       await _reSearchCurrentLocation();
                //       setState(() {
                //         _showReSearchButton = false;
                //       });
                //     },
                //     child: Container(
                //       padding:
                //           EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                //       decoration: BoxDecoration(
                //         color: Color(0xffF15A2B),
                //         borderRadius: BorderRadius.circular(16.0),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black26,
                //             blurRadius: 5.0,
                //             offset: Offset(0, 2),
                //           ),
                //         ],
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           Text(
                //             "해당 위치로 재검색",
                //             style: TextStyle(fontSize: 14, color: Colors.white),
                //           ),
                //           SizedBox(width: 8.0),
                //           Icon(Icons.refresh, color: Colors.white, size: 16.0),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),