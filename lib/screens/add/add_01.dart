import 'dart:convert'; // JSON 데이터를 다루기 위해 사용
import 'package:dongpo_test/screens/add/add_02.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart'; // Naver Map API를 사용하기 위해 사용
import 'package:geolocator/geolocator.dart'; // 위치 정보를 얻기 위해 사용
import 'package:http/http.dart' as http; // HTTP 요청을 보내기 위해 사용
import 'package:dongpo_test/api_key.dart'; // API 키를 저장한 파일을 가져오기 위해 사용
import 'package:dongpo_test/main.dart';

//등록페이지로 주소하고 위도 경도 넘기기위한 클래스
class DataForm {
  String sendAddress;
  double sendLatitude;
  double sendLongitude;

  DataForm({
    required this.sendAddress,
    required this.sendLatitude,
    required this.sendLongitude,
  });
}

late DataForm dataForm;

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late NaverMapController _mapController;
  late ValueNotifier<String> _addressNotifier;
  String _address = '';
  bool _isCameraMoving = false; // 카메라 이동 상태를 추적하기 위한 변수
  bool startAddPage = false;

  @override
  void initState() {
    super.initState();

    // 주소를 저장할 ValueNotifier 초기화
    _addressNotifier = ValueNotifier<String>('주소를 불러오는 중...');
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 전체 화면 높이
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true, // 뒤로가기 버튼 없애기
        centerTitle: true,
        title: const Text(
          "가게 등록",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); //뒤로가기
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 24,
            color: Color(0xFF767676),
          ),
        ),
      ),
      body: FutureBuilder<NLatLng>(
        future: getCurrentLocation(), // 현재 위치 정보를 가져오는 Future를 빌드
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 로딩 중일 때 로딩 인디케이터 표시
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 에러가 발생했을 때 에러 메시지 표시
            return const Center(child: Text('위치 정보를 불러오는데 실패했습니다.'));
          } else if (snapshot.hasData) {
            // 데이터가 있을 때 지도와 UI 요소를 표시
            return Stack(
              children: [
                NaverMap(
                  onMapReady: (controller) {
                    // 맵이 준비되었을 때 컨트롤러 초기화
                    logger.d("controller : ${controller.hashCode}");
                    _onMapReady(controller);
                    _mapController.updateCamera(
                      NCameraUpdate.fromCameraPosition(
                        NCameraPosition(
                          target: snapshot.data!, // 초기 카메라 위치 설정
                          zoom: 17,
                        ),
                      ),
                    );
                    startAddPage = true;
                    _isCameraMoving = false;
                  },
                  onCameraChange: (reason, animated) {
                    // 카메라가 움직일 때 상태 변경
                    _isCameraMoving = true;
                  },
                  onCameraIdle: () {
                    logger
                        .d("controller is ready? : ${_mapController.hashCode}");
                    // 카메라가 멈췄을 때 주소 업데이트
                    if (_isCameraMoving && startAddPage) {
                      _isCameraMoving = false;
                      _updateAddress();
                    }
                  },
                  options: NaverMapViewOptions(
                    //줌 확대 불가능
                    zoomGesturesEnable: false,
                    initialCameraPosition: NCameraPosition(
                      target: snapshot.data!, // 초기 카메라 위치 설정
                      zoom: 18,
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.location_on, // 중앙에 위치 핀 아이콘 표시
                    size: 48,
                    color: Color(0xFFF15A2B),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.58,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 8,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(4),
                            foregroundColor: const Color(0xFF003ACE),
                            backgroundColor: WidgetStateColor.resolveWith(
                                (states) => Colors.white)),
                        onPressed: _moveToCurrentLocation,
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenHeight * 0.3,
                      padding: const EdgeInsets.all(24.0), // 패딩 설정
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              child: const Text(
                                "가게 위치를 알려주세요",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              height: 44,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: ValueListenableBuilder<String>(
                                  valueListenable:
                                      _addressNotifier, // 주소 변경 시 업데이트
                                  builder: (context, address, child) {
                                    return Text(
                                      address,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF767676),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16), // margin
                            Container(
                              height: 44,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0, // 그림자 제거
                                  backgroundColor:
                                      const Color(0xFFF15A2B), // 버튼 색상 설정
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                ),
                                child: const Text(
                                  '가게 등록',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const GageAddSangsea()));
                                },
                              ),
                            ),
                          ],
                        ),
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
    logger.d("is controller null? : $_mapController");
    final position = await _mapController.getCameraPosition();
    final latLng = position.target;
    final address = await _reverseGeocode(latLng);
    _addressNotifier.value = address; // 주소 업데이트
    _address = address;
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
          dataForm = DataForm(
              sendAddress: data['documents'][0]['road_address']['address_name'],
              sendLatitude: latLng.latitude,
              sendLongitude: latLng.longitude);

          return data['documents'][0]['road_address']['address_name'];
        }
        // 도로명 주소가 없는 경우 지번 주소 반환
        else if (data['documents'][0]['address'] != null) {
          dataForm = DataForm(
              sendAddress: data['documents'][0]['address']['address_name'],
              sendLatitude: latLng.latitude,
              sendLongitude: latLng.longitude);
          return data['documents'][0]['address']['address_name'];
        }
      }
    }
    return '주소를 불러올 수 없습니다.';
  }

  Future<NLatLng> getCurrentLocation() async {
    // 현재 위치 정보를 가져와 NLatLng 객체로 반환
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return NLatLng(position.latitude, position.longitude);
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
}
