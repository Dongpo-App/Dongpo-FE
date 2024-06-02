import 'dart:convert'; // JSON 데이터를 다루기 위해 사용
import 'package:dongpo_test/screens/add/add_02.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart'; // Naver Map API를 사용하기 위해 사용
import 'package:geolocator/geolocator.dart'; // 위치 정보를 얻기 위해 사용
import 'package:http/http.dart' as http; // HTTP 요청을 보내기 위해 사용
import 'package:dongpo_test/api_key.dart'; // API 키를 저장한 파일을 가져오기 위해 사용
import 'dart:developer'; // 디버깅을 위해 로그를 남기기 위해 사용

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

// NaverMapController와 ValueNotifier를 전역으로 선언
late NaverMapController _mapController;
late ValueNotifier<String> _addressNotifier;

class _AddPageState extends State<AddPage> {
  bool _isCameraMoving = false; // 카메라 이동 상태를 추적하기 위한 변수

  @override
  void initState() {
    super.initState();
    // 주소를 저장할 ValueNotifier 초기화
    _addressNotifier = ValueNotifier<String>('주소를 불러오는 중...');
  }

  @override
  void dispose() {
    // ValueNotifier 메모리 해제를 위해 dispose 호출
    _addressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위치 제보'),
      ),
      body: FutureBuilder<NLatLng>(
        future: getCurrentLocation(), // 현재 위치 정보를 가져오는 Future를 빌드
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 로딩 중일 때 로딩 인디케이터 표시
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 에러가 발생했을 때 에러 메시지 표시
            return Center(child: Text('위치 정보를 불러오는데 실패했습니다.'));
          } else if (snapshot.hasData) {
            // 데이터가 있을 때 지도와 UI 요소를 표시
            return Stack(
              children: [
                NaverMap(
                  onMapReady: (controller) {
                    // 맵이 준비되었을 때 컨트롤러 초기화
                    _onMapReady(controller);
                    _mapController.updateCamera(
                      NCameraUpdate.fromCameraPosition(
                        NCameraPosition(
                          target: snapshot.data!, // 초기 카메라 위치 설정
                          zoom: 18,
                        ),
                      ),
                    );
                  },
                  onCameraChange: (reason, animated) {
                    // 카메라가 움직일 때 상태 변경
                    _isCameraMoving = true;
                  },
                  onCameraIdle: () {
                    // 카메라가 멈췄을 때 주소 업데이트
                    if (_isCameraMoving) {
                      _isCameraMoving = false;
                      _updateAddress();
                    }
                  },
                  options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                      target: snapshot.data!, // 초기 카메라 위치 설정
                      zoom: 18,
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.location_pin, // 중앙에 위치 핀 아이콘 표시
                    size: 40,
                    color: Colors.orangeAccent,
                  ),
                ),
                Container(
                  width: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(12),
                            foregroundColor: Colors.blue,
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white)),
                        onPressed: _moveToCurrentLocation,
                        child: Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0), // 패딩 설정
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "가게 위치를 알려주세요",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: ValueListenableBuilder<String>(
                                valueListenable:
                                    _addressNotifier, // 주소 변경 시 업데이트
                                builder: (context, address, child) {
                                  return Text(
                                    address,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[800],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 20, 10),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffF15A2B), // 버튼 색상 설정
                              ),
                              child: Text(
                                '여기로 등록',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return GageAddSangsea();
                                }));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<void> _updateAddress() async {
    if (_mapController != null) {
      final position = await _mapController.getCameraPosition();
      final latLng = position.target;
      final address = await _reverseGeocode(latLng);
      _addressNotifier.value = address; // 주소 업데이트
    }
  }

  Future<String> _reverseGeocode(NLatLng latLng) async {
    final url = Uri.parse(
        'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=${latLng.longitude}&y=${latLng.latitude}');
    final response = await http.get(url, headers: {
      'Authorization': 'KakaoAK $kakaoApiKey',
      'KA': 'sdk/1.0 os/flutter origin/localhost'
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['documents'].isNotEmpty) {
        // 도로명 주소가 있는 경우 반환
        if (data['documents'][0]['road_address'] != null) {
          return data['documents'][0]['road_address']['address_name'];
        }
        // 도로명 주소가 없는 경우 지번 주소 반환
        else if (data['documents'][0]['address'] != null) {
          return data['documents'][0]['address']['address_name'];
        }
      }
    }
    return '주소를 불러올 수 없습니다.';
  }
}

Future<NLatLng> getCurrentLocation() async {
  // 현재 위치 정보를 가져와 NLatLng 객체로 반환
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return NLatLng(position.latitude, position.longitude);
}

Future<void> reset_map() async {
  // 네이버 맵 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: naverApiKey,
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
}

void main() async {
  // 앱 시작 전 맵 초기화
  await reset_map();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddPage(),
    );
  }
}

void _onMapReady(NaverMapController controller) {
  // 맵 준비 완료 시 컨트롤러 초기화
  _mapController = controller;
}

Future<void> _moveToCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  _mapController.updateCamera(
    NCameraUpdate.fromCameraPosition(
      NCameraPosition(
        target: NLatLng(position.latitude, position.longitude),
        zoom: 18,
      ),
    ),
  );
}
