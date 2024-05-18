import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'main_02.dart';
import 'package:dongpo_test/api_key.dart';
import 'dart:developer';

// 지도 초기화하기
Future<void> reset_map() async {
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
            // 위치 권한이 허가되었을 때 지도를 표시합니다.
            return Stack(
              children: [
                //지도 시작
                NaverMap(
                  onMapReady: _onMapReady,
                  //지도 관련 옵션
                  options: const NaverMapViewOptions(
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
                    extent: NLatLngBounds(
                      //지도 영역을 한반도 인근으로 제한
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0),
                    ),
                  ), //지도 관련 옵션 끝
                ),
                //지도 끝
                Positioned(
                  top: 65.0,
                  left: 16.0,
                  right: 16.0,
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

          // 위치 권한이 안될 시 뜨는 오류
          // 인증 실패하면 앱 강제 종료? 로직 구현필요 or 세션만료
          // 동의 안함 했을 때 넘어가짐
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("인증을 실패했습니다")],
            ),
          );
        },
      ),
    );
  }

  // 지도가 준비되었을 때 호출되는 함수
  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
  }

  // 현재 위치로 카메라를 이동시키는 함수
  Future<void> _moveToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapController.updateCamera(
      NCameraUpdate.fromCameraPosition(
        NCameraPosition(
          target: NLatLng(position.latitude, position.longitude),
          zoom: 17,
        ),
      ),
    );
    _updateAddress(position.latitude, position.longitude);
  }

  // 현재 위치의 주소를 업데이트하는 함수
  Future<void> _updateAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.locality}' ' ' '${place.street}';
      });
    } catch (e) {
      setState(() {
        _currentAddress = '주소를 불러오지 못했습니다.';
      });
    }
  }

  // 위치 권한을 확인하는 함수
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
}

// 위치 권한을 확인 중일 때 로딩 인디케이터를 보여줍니다.
