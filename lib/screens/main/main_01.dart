import 'package:dongpo_test/models/store_detail.dart';
import 'package:dongpo_test/models/clickedMarkerInfo.dart';
import 'package:dongpo_test/models/pocha.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'package:dongpo_test/screens/login/login_view_model.dart';
import 'package:dongpo_test/screens/main/main_03/00_marker_title.dart';
import 'package:dongpo_test/screens/main/main_03/main_03.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'main_02.dart';
import 'package:dongpo_test/api_key.dart';
import 'package:permission_handler/permission_handler.dart';
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

StoreSangse? storeData; // storeData를 nullable로 변경

List<NMarker> markers = []; //마커 담는 리스트
List<MyData> myDataList = []; //가게 기본정보 담는 리스트
List<UserBookmark> userBookmark = []; //북마크 체크를 위한 클래스
late MarkerInfo markerInfo;

// 바텀시트에 표시되는 주소
String bsAddress = '';
// 검색창에 표시

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static const storage = FlutterSecureStorage();

  //애니메이션 컨트롤러를 사용하는 위젯에 필요한 Ticker를 제공
  late NaverMapController _mapController;
  String _searchBarInnerText = "구, 동, 도로명, 장소명으로 검색";
  bool _showReSearchButton = false; // 재검색 버튼 표시 여부
  NMarker? _selectedMarker;
  late NMarker _userMarker;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == "위치 권한이 허가 되었습니다.") {
            return Stack(
              children: [
                //네이버 지도 시작
                NaverMap(
                  onMapReady: (controller) async {
                    logger.d("controller : ${controller.hashCode}");
                    _onMapReady(controller);
                    await _initUserMarker();
                    await _moveCamera(_userMarker.position);
                    await _searchStoreCurrentLocation(_userMarker.position);
                    logger.d(
                        "초기 마커 생성 sample : ${myDataList.isEmpty ? "마커가 안들어있음" : myDataList[0]}");
                    setState(() {
                      _showReSearchButton = false;
                    });
                  },
                  onMapTapped: (point, latLng) {
                    if (_selectedMarker != null) {
                      setState(() {
                        Navigator.pop(context);
                        _selectedMarker!.setIcon(
                            const NOverlayImage.fromAssetImage(
                                'assets/images/defaultMarker.png'));
                        _selectedMarker = null;
                        // 추가로 바텀 시트도 닫히게 해야함
                      });
                    }
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
                  options: const NaverMapViewOptions(
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
                    onTap: () async {
                      // 검색에서 선택한 결과를 기다림
                      final searchResult = await Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const AddressSearchPage();
                      }));
                      logger.d("search result is $searchResult");
                      // 검색 결과가 있는 경우 해당 위치로 이동
                      if (searchResult != null) {
                        NLatLng target = NLatLng(
                          double.parse(searchResult['lat']),
                          double.parse(searchResult['lng']),
                        );
                        _searchBarInnerText = searchResult['place_name'];
                        logger.d("검색창에 표시할 데이터 : $_searchBarInnerText");
                        await _moveCamera(target);
                        await _searchStoreCurrentLocation(target);
                        logger.d(
                            "검색 이후 마커 생성 : sample ${myDataList.isEmpty ? "no sample" : myDataList[0]}");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
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
                          const SizedBox(width: 8.0),
                          Text(
                            _searchBarInnerText,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF767676),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.search,
                            color: Color(0xFF767676),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 바텀 슬라이드
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                    position: _offsetAnimation, // 슬라이더 애니메이션 적용
                    child: Container(
                      padding: const EdgeInsets.only(top: 24, left: 24),
                      height: 200, // 튀어나오는 부분을 포함한 전체 높이
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bsAddress,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 24),
                            height: 90,
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: myDataList.length,
                              itemBuilder: (BuildContext ctx, int idx) {
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return StoreInfo(
                                                  idx: idx +
                                                      1); // 터치하면 해당 가게 상세보기로
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        height: 100,
                                        width: 220,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                              width: 40,
                                              child: CircleAvatar(
                                                minRadius: 15,
                                                backgroundImage: AssetImage(
                                                    'assets/images/rakoon.png'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${myDataList[idx].name}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .lightbulb_outline_rounded,
                                                      size: 12,
                                                      color: Color(0xffF15A2B),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '영업 가능성 있어요!',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF767676),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //위치 재검색 버튼
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: _showReSearchButton ? 120.0 : -40.0,
                  left: MediaQuery.of(context).size.width / 3.5,
                  right: MediaQuery.of(context).size.width / 3.5,
                  child: GestureDetector(
                    onTap: () async {
                      final position = await _mapController.getCameraPosition();
                      await _searchStoreCurrentLocation(position.target);
                      setState(() {
                        _showReSearchButton = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xffF15A2B),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "해당 위치로 재검색",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 8,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(4),
                              foregroundColor: Color(0xFF003ACE),
                              backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.white)),
                          onPressed: () async {
                            NLatLng target = await _getCurrentNLatLng();
                            _userMarker.setPosition(target);
                            await _moveCamera(target);
                            await _searchStoreCurrentLocation(target);
                          },
                          child: const Icon(Icons.my_location),
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
                            icon: const Icon(
                              Icons.remove,
                              size: 36,
                              color: Color(0xFF767676),
                            )),
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
    logger.d('마커가 정상적으로 들어왔음 ${markers.length}');
    for (int i = 0; i < markers.length; i++) {
      await _mapController.deleteOverlay(NOverlayInfo(
          type: NOverlayType.marker, id: markers[i].info.id)); // 마커 제거
    }
    // _mapController.clearOverlays(); // 전체 삭제 -> 유저 마커 삭제
    markers.clear(); // 리스트 초기화
    logger.d('마커삭제 테스트 $markers');
  }

  // 해당 위치 재검색 클릭 시 마커 여러 개 보여주는 함수
  void _addMarkers(List<MyData> dataList) async {
    //여러개 마커 담는 리스트
    try {
      var defaultMarkerSize = const Size(32, 40);
      await _clearMarkers(); // 기존 마커 제거
      for (var data in dataList) {
        NMarker marker = NMarker(
          id: data.id.toString(),
          position: NLatLng(data.latitude, data.longitude),
          icon: const NOverlayImage.fromAssetImage(
              'assets/images/defaultMarker.png'),
        );
        //마커 사이즈 조절
        marker.setSize(defaultMarkerSize);
        marker.setOnTapListener((overlay) {
          _onMarkerTapped(marker, data);
        });
        _mapController.addOverlay(marker);
        // 마커 리스트에 추가
        markers.add(marker);
      }
    } catch (e) {
      logger.w('에러발생 :$e');
    }
  }

  // 마커 클릭 이벤트 함수
  void _onMarkerTapped(NMarker marker, MyData data) {
    logger.d("onMakerTapped start");
    setState(() {
      if (_selectedMarker != null) {
        _selectedMarker!.setIcon(const NOverlayImage.fromAssetImage(
            'assets/images/defaultMarker.png'));
      }
      _selectedMarker = marker;
    });
    try {
      marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/images/clickedMarker.png'));

      //해당 위치로 이동
      logger.d("클릭된 마커 id =  ${marker.info.id}");
      _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(data.latitude, data.longitude),
            zoom: 16,
          ),
        ),
      );
      _showBottomSheet(
        context,
        marker.info.id,
      );
      _showReSearchButton = false;
    } catch (e) {
      logger.d('에러발생 $e');
    } finally {
      logger.d('finally 실행');
    }
  }

  // 사용자 마커 초기화
  Future<void> _initUserMarker() async {
    NLatLng position = await _getCurrentNLatLng();
    // 사용자 위치 아이콘 에셋 지정
    const myLocationIcon =
        NOverlayImage.fromAssetImage('assets/icon/my_location.png');
    // 마커 객체 생성
    _userMarker = NMarker(
      id: "my_location_marker",
      position: position,
      icon: myLocationIcon,
    );
    // 마커 사이즈 지정 및 지도에 추가
    _userMarker.setSize(const Size(24, 24));
    _mapController.addOverlay(_userMarker);
  }

  // 카메라 위치 기반으로 근처 가게 검색
  Future<List<MyData>> _researchFromMe() async {
    //해당 카메라 기준 위도경도 가져옴

    try {
      final cameraPosition = await _mapController.getCameraPosition();
      final latitude = cameraPosition.target.latitude;
      final longitude = cameraPosition.target.longitude;
      logger.d("researchFromME:$cameraPosition");
      final accessToken = await storage.read(key: 'accessToken');
      logger.d('_researchFromMe() http통신 전 ');
      final url = Uri.parse(
          '$serverUrl/api/store?longitude=$longitude&latitude=$latitude');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        logger.d('데이터 통신 성공 !! 상태코드 : ${response.statusCode}');
        List jsonResponse =
            json.decode(utf8.decode(response.bodyBytes))['data'];
        return jsonResponse.map((myData) => MyData.fromJson(myData)).toList();
      } else if (response.statusCode == 401) {
        logger.d('token expired! status code : ${response.statusCode}');
        await reissue(context);
        return _researchFromMe();
      } else {
        logger.e(
            'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : ${response.body}');
        throw Exception('HTTP ERROR !!! ${response.body}');
      }
    } catch (e) {
      // TODO
      logger.d('Error in _researchFromMe method 에러내용 : $e');
      throw {logger.d('Error !! ')};
    }
  }

  Future<void> _searchStoreCurrentLocation(NLatLng target) async {
    // 점포 데이터 받기

    try {
      List<MyData> storeList = await _researchFromMe();

      myDataList = storeList;
      bsAddress = await _reverseGeocode(target);

      _addMarkers(storeList);
    } catch (e) {
      logger.d('_searchStoreCurrentLocation 함수 오류 ');
    }
  }

  // 현재 위치를 NLatLng 으로 받기
  Future<NLatLng> _getCurrentNLatLng() async {
    Position position = await Geolocator.getCurrentPosition();
    return NLatLng(position.latitude, position.longitude);
  }

  // 위치 정보를 받아 해당 위치로 이동
  // 내 위치로 또는 특정 위치로 이동
  Future<void> _moveCamera(NLatLng position) async {
    try {
      // 카메라 이동
      await _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: position,
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      logger.e("Error in _moveToCurrentLocation: $e");
    }
  }

  // 위치권한
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
            title: const Text('위치 권한 필요!'),
            content: const Text('이 앱은 위치 권한이 필요합니다. 권한을 허용해주세요.'),
            actions: <Widget>[
              TextButton(
                child: const Text('앱 종료'),
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
                  child: const Text("설정으로 이동"))
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

    late String address;

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
          address =
              "${data['documents'][0]['road_address']['region_2depth_name']} ${data['documents'][0]['road_address']['road_name']}";
          return address;
        }
        // 도로명 주소가 없는 경우 지번 주소 반환
        else if (data['documents'][0]['address'] != null) {
          dataForm = DataForm(
              sendAddress: data['documents'][0]['address']['address_name'],
              sendLatitude: latLng.latitude,
              sendLongitude: latLng.longitude);
          address =
              "${data['documents'][0]['address']['region_2depth_name']} ${data['documents'][0]['address']['region_3depth_name']}  ";
          return address;
        }
      }
    }
    return ' ';
  }

  //가게 기본정보 바텀시트
  void _showBottomSheet(BuildContext context, String markerId) async {
    int index = int.parse(markerId);
    markerInfo = await _getClickedMarkerInfo(context, index);
    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.35,
          minChildSize: 0.35,
          shouldCloseOnMinExtent: false,
          snap: true,
          snapAnimationDuration: const Duration(milliseconds: 300),
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StoreInfo(idx: index);
                      })),
                      child: const Icon(Icons.menu),
                    ),
                    MainTitle2(
                      idx: index,
                    ),
                    //사진
                    const SizedBox(
                      height: 30,
                    ),
                    const MainPhoto2(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //마커 서버통신
  Future<MarkerInfo> _getClickedMarkerInfo(
      BuildContext context, int markerId) async {
    final url = Uri.parse('$serverUrl/api/store/$markerId/summary');

    final accessToken = await storage.read(key: 'accessToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      logger.d('데이터 통신 성공 !! (Marker) 상태코드 : ${response.statusCode}');

      // 단일 객체를 처리하는 부분
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes))['data'];
      return MarkerInfo.fromJson(jsonResponse); // 객체로 변환
    } else if (response.statusCode == 401) {
      logger.d('token expired! 상태코드 : ${response.statusCode}');
      await reissue(context); // 토큰 갱신 함수
      return _getClickedMarkerInfo(context, markerId); // 갱신 후 다시 호출
    } else {
      logger.e(
          'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : ${response.body}');
      throw Exception('HTTP ERROR !!! ${response.body}');
    }
  }
}
