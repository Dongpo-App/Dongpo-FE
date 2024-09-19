import 'package:dongpo_test/models/pocha.dart';
import 'package:dongpo_test/screens/main/main_03/main_03.dart';

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
import 'package:dongpo_test/screens/main/main_03/03_title.dart';
import 'package:dongpo_test/screens/main/main_03/03_photo_List.dart';
import 'package:dongpo_test/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dongpo_test/screens/add/add_01.dart';

/*
메인페이지 맨처음 보여줄 때 
 1)내위치로 카메라 옮기기 => init 초기화할때 함수 사용
 2) 마커 여러개 표시 => 냅둬 
 3) 등록한 가게 전체조회해서 마커 추가 => get 리스트에 담고 마커 여러개 출력 
*/

//여러개 띄울 마커 받아놓을 마커리스트
List<NMarker> _markers = [];
List<MyData> myDataList = [];

//바텀시트에 표시되는 주소
String bsAddress = '';

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

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static final storage = FlutterSecureStorage();

  //애니메이션 컨트롤러를 사용하는 위젯에 필요한 Ticker를 제공
  late NaverMapController _mapController;
  String _currentAddress = "";
  bool _showReSearchButton = false;
  late AnimationController _controller; // 애니메이션 컨트롤러 선언
  late Animation<Offset> _offsetAnimation; // 슬라이더 애니메이션 선언
  late Animation<double> _buttonAnimation; // 버튼 애니메이션 선언
  late Animation<double> _locationBtn;

  @override
  //초기화
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

    //내 위치 버튼 애니메이션 설정
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

  // UI 여기부터 시작
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
                  onMapReady: (controller) async {
                    _onMapReady(controller);
                    _moveToCurrentLocation();
                  },

                  //렉 유발 하는 듯 setstate로 인한 지도 재호출
                  // 카메라 변경 이벤트 시 상태 업데이트 최소화
                  onCameraChange: (reason, animated) {
                    if (!_showReSearchButton) {
                      setState(() {
                        _showReSearchButton = true;
                      });
                    }
                  },
                  options: NaverMapViewOptions(
                    locationButtonEnable: false, // 위치 버튼 표시 여부 설정
                    minZoom: 15, //쵀대 줄일 수 있는 크기?
                    maxZoom: 18, //최대 당길 수 있는 크기
                    initialCameraPosition: NCameraPosition(
                      //첫 로딩시 카메라 포지션 지정
                      target: NLatLng(37.49993604717163, 126.86768245932946),
                      zoom: 16, bearing: 0,
                    ),
                  ),
                ),
                //네이버 맵 끝
                Positioned(
                  top: 65.0,
                  left: 16.0,
                  right: 16.0,
                  //상단 검색바
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AddressSearchPage();
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
                            _currentAddress.length > 28
                                ? '${_currentAddress.substring(0, 28)}...'
                                : _currentAddress,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[400]),
                          ),
                          Spacer(),
                          Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                ),

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
                              bsAddress,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 90,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: myDataList.length,
                                  itemBuilder: (BuildContext ctx, int idx) {
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return StoreInfo(); //터치하면 해당 가게 상세보기로
                                            }));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 20, 20, 20),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            height: 100,
                                            child: Row(
                                              children: [
                                                //CircleAvatar 컨테이너
                                                Container(
                                                  height: 30,
                                                  width: 40,
                                                  child: CircleAvatar(
                                                    minRadius: 15,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/rakoon.png'),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${myDataList[idx].name}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          size: 13,
                                                          color:
                                                              Color(0xffF15A2B),
                                                        ),
                                                        Text(
                                                          '영업 가능성 있어요!',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              fontSize: 10),
                                                        )
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

                //위치 재검색 버튼
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  top: _showReSearchButton ? 110.0 : -40.0,
                  left: MediaQuery.of(context).size.width / 3.5,
                  right: MediaQuery.of(context).size.width / 3.5,
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
                        children: [
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
                // 왼쪽 하단 내 위치 재검색 버튼
                AnimatedBuilder(
                    animation: _locationBtn,
                    builder: (context, child) {
                      return Positioned(
                        bottom: _locationBtn.value,
                        left: 16.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(12),
                              foregroundColor: Colors.blue,
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

  //마커 관련
// 기존 마커 삭제 함수
  Future<void> _clearMarkers() async {
    logger.d('마커가 정상적으로 들어왔음 ${_markers}');
    // for (int i =0 ; i >= _markers.length; i++) {
    //   _mapController
    //       .deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id:  )); // 마커 제거
    // }
    _mapController.clearOverlays();
    _markers.clear(); // 리스트 초기화
    logger.d('마커삭제 테스트 $_markers');
  }

// 해당 위치 재검색 클릭 시 마커 여러 개 보여주는 함수
  void _addMarkers(List<MyData> dataList) async {
    //여러개 마커 담는 리스트
    try {
      var defaultMarkerSize = Size(40, 50);
      await _clearMarkers(); // 기존 마커 제거
      for (var data in dataList) {
        var markerIcon = await NOverlayImage.fromAssetImage(
            'assets/images/defalutMarker.png');

        NMarker marker = NMarker(
          id: data.id.toString(),
          position: NLatLng(data.latitude!, data.longitude!),
          icon: markerIcon,
        );
        //마커 사이즈 조절
        marker.setSize(defaultMarkerSize);
        marker.setOnTapListener((overlay) {
          _onMarkerTapped(marker, data);
        });
        _mapController.addOverlay(marker);
        // 마커 리스트에 추가
        _markers.add(marker);
      }
    } catch (e) {
      logger.w('에러발생 :$e');
    }
  }

  //마커 클릭 이벤트 함수
  void _onMarkerTapped(NMarker marker, MyData data) {
    try {
      marker.setIcon(
          NOverlayImage.fromAssetImage('assets/images/clickedMarker.png'));
      //해당 위치로 이동

      _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(data.latitude!, data.longitude!),
            zoom: 16,
          ),
        ),
      );
      _showBottomSheet(context);
    } catch (e) {
      logger.d('에러발생 $e');
    } finally {
      logger.d('finally 실행');
    }
  }

  //해당 위치로 재검색
  Future<void> _reSearchCurrentLocation() async {
    //서버에 위도경도 보내서 데이터 더미로 받아와야함
    List<MyData> myList = await _researchFromMe();

    //받아온 데이터 myDataList에 넣기
    myDataList = myList;
    _addMarkers(myList);
    late String getAddress;
    //하단 주소 업뎃
    try {
      final position = await _mapController.getCameraPosition();
      final latLng = position.target;
      final myLocation = NLatLng(latLng.latitude, latLng.longitude);
      getAddress = await _reverseGeocode(myLocation);
      logger.d("안에 든 내용 : $getAddress");
    } on Exception catch (e) {
      // TODO
      logger.w("Error! 내용: $e 위치: _reSearchCurrentLocation() ");
    }

    bsAddress = getAddress;
  }

  //내위치 기반으로 근처 가게 검색
  Future<List<MyData>> _researchFromMe() async {
    //해당 카메라 기준 위도경도 가져옴

    final cameraPosition = await _mapController.getCameraPosition();
    final latitude = cameraPosition.target.latitude;
    final longitude = cameraPosition.target.longitude;

    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse(
        '$serverUrl/api/store?longitude=$longitude&latitude=$latitude');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      logger.d('데이터 통신 성공 !! 상태코드 : ${response.statusCode}');
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes))['data'];
      final List<MyData> myDataList =
          jsonResponse.map((myData) => MyData.fromJson(myData)).toList();
      return myDataList;
    } else {
      logger.e(
          'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : ${response.body}');
      throw Exception('HTTP ERROR !!! ${response.body}');
    }
  }

  //내위치로 이동
  Future<void> _moveToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final myLocation = NLatLng(position.latitude, position.longitude);

      final myLocationIcon =
          NOverlayImage.fromAssetImage('assets/images/myLocation.png');

      NMarker myLocationMarker = NMarker(
        id: "my_location_marker",
        position: myLocation,
        icon: myLocationIcon,
      );

      myLocationMarker.setSize(Size(40, 50));
      _mapController.addOverlay(myLocationMarker);

      _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: myLocation,
            zoom: 16,
          ),
        ),
      );
      _updateAddress(position.latitude, position.longitude);
    } catch (e) {
      // 에러 발생 시 로그 출력
      logger.d("Error in _moveToCurrentLocation: $e");
    }
  }

  // 주소 띄우기
  Future<void> _updateAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.locality} ' '${place.street} ';
      });
    } catch (e) {
      logger.d('주소 찾지못함');
    }
  }

  //위치권한
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
                  logger.d('앱 종료');
                },
              ),
              TextButton(
                  onPressed: () {
                    logger.d('설정으로 이동');
                    openAppSettings();
                  },
                  child: Text("설정으로 이동"))
            ],
          );
        },
      );
    });
  }

  //
  Future<String> _reverseGeocode(NLatLng latLng) async {
    final url = Uri.parse(
        'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=${latLng.longitude}&y=${latLng.latitude}');
    final response = await http.get(url, headers: {
      'Authorization': 'KakaoAK $kakaoApiKey',
      'KA': 'sdk/1.0 os/flutter origin/localhost'
    });

    late String _address;

    logger.d('statusCode : ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['documents'].isNotEmpty) {
        // 도로명 주소가 있는 경우 반환
        if (data['documents'][0]['road_address'] != null) {
          dataForm = DataForm(
              sendAddress: data['documents'][0]['road_address']['address_name'],
              sendLatitude: latLng.latitude,
              sendLongitude: latLng.longitude);
          _address =
              "${data['documents'][0]['road_address']['region_2depth_name']} ${data['documents'][0]['road_address']['road_name']}";
          return _address;
        }
        // 도로명 주소가 없는 경우 지번 주소 반환
        else if (data['documents'][0]['address'] != null) {
          dataForm = DataForm(
              sendAddress: data['documents'][0]['address']['address_name'],
              sendLatitude: latLng.latitude,
              sendLongitude: latLng.longitude);
          _address =
              "${data['documents'][0]['address']['region_2depth_name']} ${data['documents'][0]['address']['region_3depth_name']}  ";
          return _address;
        }
      }
    }
    return ' ';
  }

  //가게 기본정보 바텀시트
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: MediaQuery.of(context).size.height * 0.36,
          decoration: BoxDecoration(),
          child: Column(
            children: [
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return StoreInfo();
                })),
                child: Icon(Icons.menu),
              ),
              //제목, 영업가능성, 거리
              MainTitle(),
              //사진
              SizedBox(
                height: 30,
              ),
              MainPhoto(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
