import 'package:dongpo_test/models/response/api_response.dart';
import 'package:dongpo_test/models/store/clicked_marker_info.dart';
import 'package:dongpo_test/models/store/store_marker.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'package:dongpo_test/screens/login/login.dart';
import 'package:dongpo_test/screens/main/main_03/00_marker_title.dart';
import 'package:dongpo_test/screens/main/main_03/main_03.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:dongpo_test/service/store_service.dart';
import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'main_02.dart';
import 'package:dongpo_test/api_key.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dongpo_test/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*
메인페이지 맨처음 보여줄 때 
1)내위치로 카메라 옮기기 => init 초기화할때 함수 사용
2) 마커 여러개 표시 => 냅둬 
3) 등록한 가게 전체조회해서 마커 추가 => get 리스트에 담고 마커 여러개 출력 
*/

//여러개 띄울 마커 받아놓을 마커리스트
//StoreDetail? storeData; // storeData를 nullable로 변경
//List<NMarker> markers = []; //마커 담는 리스트
//List<StoreMarker> manager.storeList = []; //가게 기본정보 담는 리스트
List<UserBookmark> userBookmark = []; //북마크 체크를 위한 클래스
//late MarkerInfo markerInfo;

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
  StoreApiService storeService = StoreApiService.instance;
  MapManager manager = MapManager();
  //애니메이션 컨트롤러를 사용하는 위젯에 필요한 Ticker를 제공
  String _searchBarInnerText = "구, 동, 도로명, 장소명으로 검색";
  bool _showReSearchButton = false; // 재검색 버튼 표시 여부
  //NMarker? _selectedMarker;
  late NMarker _userMarker;
  late AnimationController _controller; // 애니메이션 컨트롤러 선언
  late Animation<Offset> _offsetAnimation; // 슬라이더 애니메이션 선언
  late Animation<double> _buttonAnimation; // 버튼 애니메이션 선언
  late Animation<double> _locationBtn;

  // 로딩
  bool isLoading = false;

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

    // 내 위치 버튼 애니메이션 설정
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
    manager.mapController.dispose();
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
      backgroundColor: Colors.white,
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
                    manager.initialize(controller);
                    await manager.clearMarkers(); // 기존 마커 제거
                    await _initUserMarker();
                    await manager.moveCamera(_userMarker.position);
                    await _searchStoreCurrentLocation(_userMarker.position);
                    logger.d("marker init : ${manager.storeList.length}");
                    setState(() {
                      _showReSearchButton = false;
                    });
                  },
                  onMapTapped: (point, latLng) {
                    logger.d("selected : ${manager.selectedMarker}");
                    logger.d("controller : ${manager.mapController.hashCode}");
                    if (manager.selectedMarker != null) {
                      setState(() {
                        manager.deselectMarker();
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
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
                    pickTolerance:
                        16, // 마커나 오버레이에 정확하게 닿지 않더라도, 설정된 픽셀 범위 내에 있으면 터치로 인식
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
                        await manager.moveCamera(target);
                        await _searchStoreCurrentLocation(target);
                        setState(() {
                          _showReSearchButton = false;
                        });
                        logger.d(
                            "marker after search : ${manager.storeList.length}");
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
                      padding: const EdgeInsets.only(top: 24),
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              bsAddress,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 24),
                            height: 90,
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: manager.storeList.length,
                              itemBuilder: (BuildContext ctx, int idx) {
                                return Row(
                                  children: [
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return StoreInfo(
                                                  idx: manager.storeList[idx]
                                                      .id); // 터치하면 해당 가게 상세보기로
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        height: 100,
                                        width: 220,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 32,
                                              width: 32,
                                              child: CircleAvatar(
                                                minRadius: 16,
                                                backgroundImage: AssetImage(
                                                    'assets/images/icon.png'),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 100),
                                                  child: Text(
                                                    manager.storeList[idx].name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '영업 가능성 있어요!',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                        color: Colors.black,
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
                      final position =
                          await manager.mapController.getCameraPosition();
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
                              foregroundColor: const Color(0xFF003ACE),
                              backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.white)),
                          onPressed: () async {
                            NLatLng target =
                                await MapManager.getCurrentNLatLng();
                            _userMarker.setPosition(target);
                            await manager.moveCamera(target);
                            await _searchStoreCurrentLocation(target);
                            setState(() {
                              _showReSearchButton = false;
                            });
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

  // 마커 클릭 이벤트 함수
  void _onMarkerTapped(NMarker marker, StoreMarker data) {
    logger.d("onMakerTapped start");
    setState(() {
      if (manager.selectedMarker != null) {
        manager.selectedMarker!.setIcon(const NOverlayImage.fromAssetImage(
            'assets/icons/default_marker.png'));
      }
      manager.selectedMarker = marker;
    });

    try {
      marker.setZIndex(500);
      marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/icons/clicked_marker.png'));

      //해당 위치로 이동
      logger.d("클릭된 마커 id =  ${marker.info.id}");
      manager.moveCamera(NLatLng(data.latitude, data.longitude));

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
    NLatLng position = await MapManager.getCurrentNLatLng();
    // 사용자 위치 아이콘 에셋 지정
    const myLocationIcon =
        NOverlayImage.fromAssetImage('assets/icons/my_location.png');
    // 마커 객체 생성
    _userMarker = NMarker(
      id: "my_location_marker",
      position: position,
      icon: myLocationIcon,
    );
    _userMarker.setZIndex(100);
    // 마커 사이즈 지정 및 지도에 추가
    _userMarker.setSize(const Size(24, 24));
    manager.mapController.addOverlay(_userMarker);
  }

  Future<void> _searchStoreCurrentLocation(NLatLng target) async {
    // 점포 데이터 받기

    try {
      ApiResponse<List<StoreMarker>> response =
          await storeService.getStoreByCurrentLocation(
        target.latitude,
        target.longitude,
      );

      if (response.statusCode == 200 && response.data != null) {
        bsAddress = await _reverseGeocode(target);
        manager.addMarkers(
          response.data!,
          (marker, store) {
            _onMarkerTapped(marker, store);
            logger.d("main marker ontap : ${store.id}");
          },
        );
      } else {
        logger.e("Erorr in fetching store list: ${response.message}");
      }
    } on TokenExpiredException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("세션이 만료되었습니다. 다시 로그인해주세요.")));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        logger.e("Error! while replace to Login page");
        logger.e("message: $e");
      }
    } on Exception catch (e) {
      logger.e("Error! message: $e");
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
          address =
              "${data['documents'][0]['road_address']['region_2depth_name']} ${data['documents'][0]['road_address']['road_name']}";
          return address;
        }
        // 도로명 주소가 없는 경우 지번 주소 반환
        else if (data['documents'][0]['address'] != null) {
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
    double screenHeight = MediaQuery.of(context).size.height;
    bool isNavigating = false;
    int index = int.parse(markerId);
    try {
      ApiResponse<MarkerInfo> response =
          await storeService.getStoreSummary(index);
      if (response.statusCode == 200 && response.data != null) {
        manager.selectedSummary = response.data!;
      }
    } catch (e) {
      logger.e("Error in show bottomSheet");
    }
    if (mounted) {
      showBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.4, // 드래그할 최대 크기 설정
            shouldCloseOnMinExtent: false,
            snap: true,
            snapSizes: const [0.1, 0.4],
            snapAnimationDuration: const Duration(milliseconds: 300),
            builder: (context, scrollController) {
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (!isNavigating) {
                    logger.d(
                        "extentBefore : ${scrollNotification.metrics.extentBefore}");
                    logger.d("screenHeight :; $screenHeight");
                    // 상단으로 드래그
                    if (scrollNotification.metrics.extentBefore >=
                        screenHeight * 0.02) {
                      isNavigating = true;
                      setState(() {
                        manager.deselectMarker();
                      });
                      if (mounted) {
                        // 페이지 전환
                        Navigator.popAndPushNamed(
                          context,
                          '/storeInfo',
                          arguments: index, // index 값을 전달
                        ).then((_) {
                          isNavigating = false; // 페이지 이동 후 플래그 해제
                        });
                      }
                      return true;
                    }
                    // 하단으로 드래그
                    if (scrollNotification.metrics.extentInside <=
                        screenHeight * 0.2) {
                      // minScrollExtent * 1.3 으로 최소 영역 하한 조정
                      setState(() {
                        manager.deselectMarker();
                      });
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context); // 현재 bottom sheet 닫기
                      }
                      logger.i("페이지 pop 성공");
                      return true;
                    }
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: [
                        const Icon(
                          size: 36,
                          Icons.remove,
                          color: Color(0xff767676),
                        ),
                        StoreSummaryTitle(idx: index),
                        const SizedBox(height: 32),
                        const MainPhoto2(),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}
