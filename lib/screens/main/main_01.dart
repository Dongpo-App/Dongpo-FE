import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'main_02.dart';
import 'package:dongpo_test/api_key.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// 지도 초기화하기
Future<void> reset_map() async {
  // splash 화면 종료
  FlutterNativeSplash.remove();

  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: naverApiKey, // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late NaverMapController _mapController;
  String _currentAddress = "";
  bool _showReSearchButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == "위치 권한이 허가 되었습니다.") {
            return Stack(
              children: [
                //네이버 지도 시작
                NaverMap(
                  onMapReady: _onMapReady,
                  onCameraChange: (reason, animated) {
                    setState(() {
                      _showReSearchButton = true;
                    });
                  },
                  options: NaverMapViewOptions(
                    indoorEnable: true, // 실내 맵 사용 가능 여부 설정
                    locationButtonEnable: false, // 위치 버튼 표시 여부 설정
                    minZoom: 16, //쵀대 줄일 수 있는 크기?
                    maxZoom: 18, //최대 당길 수 있는 크기
                    initialCameraPosition: NCameraPosition(
                      //첫 로딩시 카메라 포지션 지정
                      target: NLatLng(37.49993604717163, 126.86768245932946),
                      zoom: 16, bearing: 0,
                      tilt: 0,
                    ),
                  ),
                ),
                Positioned(
                  top: 65.0,
                  left: 16.0,
                  right: 16.0,
                  //상단 검색바
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return SearchPage();
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      //검색바 안에 주소
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 8.0),
                          Text(
                            _currentAddress,
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[400]),
                          ),
                          Spacer(),
                          Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                ),
                //위치 재검색 버튼
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  top: _showReSearchButton ? 110.0 : -40.0,
                  left: MediaQuery.of(context).size.width / 4,
                  right: MediaQuery.of(context).size.width / 4,
                  child: GestureDetector(
                    onTap: () async {
                      await _reSearchCurrentLocation();
                      setState(() {
                        _showReSearchButton = false;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Color(0xffF15A2B),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "해당 위치로 재검색",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(width: 8.0),
                          Icon(Icons.refresh, color: Colors.white, size: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
                // 내 위치 버튼
                Positioned(
                  bottom: 90.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: _moveToCurrentLocation,
                    child: Icon(Icons.my_location),
                  ),
                ),
              ],
            );
          }
          // 권한이 거절되었을 시 알림 표시 후 앱 종료
          else {
            _showPermissionDenied();
            return Container();
          }
        },
      ),
    );
  }

  // 함수 정의

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
          zoom: 15,
        ),
      ),
    );
    _updateAddress(position.latitude, position.longitude);
  }

  Future<void> _updateAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.locality} ' '${place.street} ';
      });
    } catch (e) {
      setState(() {
        _currentAddress = '주소를 불러오지 못했습니다.';
      });
    }
  }

  Future<void> _reSearchCurrentLocation() async {
    final cameraPosition = await _mapController.getCameraPosition();
    final latitude = cameraPosition.target.latitude;
    final longitude = cameraPosition.target.longitude;
    print('현재 지도의 중앙 좌표: 위도 $latitude, 경도 $longitude');
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    return '위치 권한이 허가 되었습니다.';
  }

  // 위치 권한 거절 시 알림 표시 후 앱 종료
  void _showPermissionDenied() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('위치 권한 필요!'),
            content: Text('이 앱은 위치 권한이 필요합니다. 권한을 허용해주세요.'),
            actions: <Widget>[
              TextButton(
                child: Text('앱 종료'),
                onPressed: () {
                  SystemNavigator.pop(); // 앱 종료
                  print('앱 종료');
                },
              ),
              TextButton(
                  onPressed: () {
                    print('설정으로 이동');
                    openAppSettings();
                  },
                  child: Text("설정으로 이동"))
            ],
          );
        },
      );
    });
  }

  //마커를 지도에 띄우는 함수
  // Future<void> showMarker() async {
  //   for (int i in phoChaList) {
  //     NMarker marker = NMarker(
  //         id: "marker_$i",
  //         position: NLatLng(phoChaList[i].latitude, phoChaList[i].longitude));
  //     _mapController.addOverlay(marker);
  //   }
  // }
}
