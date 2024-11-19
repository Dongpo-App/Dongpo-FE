import 'dart:convert';
import 'package:dongpo_test/screens/login/login_view_model.dart';
import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dongpo_test/main.dart';
import 'package:http/http.dart' as http;

class BangMoon extends StatelessWidget {
  final MapManager manager = MapManager();
  final bool isVisitCertChecked;

  BangMoon({super.key, required this.isVisitCertChecked});

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 좌우 마진 제외
    final contentsWidth = screenWidth - 48;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          '방문에 성공하셨나요?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //방문 성공 컨테이너
            Container(
              height: 48,
              width: contentsWidth * 0.48,
              decoration: BoxDecoration(
                  color: const Color(0x3313C925),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                      size: 24,
                      color: Color(0xFF10AA1F),
                      Icons.sentiment_satisfied_alt),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    '방문 성공 ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${manager.selectedDetail?.visitSuccessfulCount ?? 0} 회',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            //방문 실패 컨테이너
            Container(
              height: 48,
              width: contentsWidth * 0.48,
              decoration: BoxDecoration(
                  color: const Color(0x33C91E13),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    color: Color(0xFFAD271F),
                    Icons.sentiment_dissatisfied_outlined,
                    size: 24,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    '방문 실패 ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${manager.selectedDetail?.visitFailCount ?? 0} 회',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        SizedBox(
          height: 44,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              isVisitCertChecked
                  ? null
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const BangMoonPage()));
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              backgroundColor: isVisitCertChecked
                  ? const Color(0xFFF4F4F4)
                  : const Color(0xffF15A2B),
            ),
            child: Text(
              isVisitCertChecked ? '24시간 동안 리뷰 작성과 가게 신고가 가능해요' : '방문 인증 하기',
              style: TextStyle(
                  fontSize: 14,
                  color: isVisitCertChecked
                      ? const Color(0xFF767676)
                      : Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ]),
    );
  }
}

// 방문 인증 페이지
class BangMoonPage extends StatefulWidget {
  const BangMoonPage({super.key});

  @override
  State<BangMoonPage> createState() => _BangMoonPageState();
}

class _BangMoonPageState extends State<BangMoonPage> {
  MapManager manager = MapManager();
  late NaverMapController mapController;
  int okValue = 0;
  int noValue = 0;

  // 방문 인증 상태 관리 변수
  bool isLoading = false;

  @override
  //초기화
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 전체 화면 높이
    final screenHeight = MediaQuery.of(context).size.height;
    // 좌우 마진 제외 너비
    final contentsWidth = screenWidth - 48;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
        centerTitle: true,
        title: const Text(
          "가게 방문 인증",
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
        future: manager.getCorrectionPosition(), // 현재 위치 정보를 가져오는 Future를 빌드
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
                    mapController = controller;
                    mapController.updateCamera(
                      NCameraUpdate.fromCameraPosition(
                        NCameraPosition(
                          target: snapshot.data!, // 초기 카메라 위치 설정
                          zoom: 17,
                        ),
                      ),
                    );
                    _setMyMarkerAndStoreMarker();
                  },
                  options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                        target: NLatLng(
                          manager.selectedMarkerInfo!.latitude,
                          manager.selectedMarkerInfo!.longitude,
                        ),
                        zoom: 17),
                    zoomGesturesEnable: false,
                    minZoom: 16,
                    scrollGesturesEnable: false,
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
                        onPressed: _checkDistance,
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
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              child: const Text(
                                "가게 방문 인증",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //방문 성공 버튼
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      okValue = 1;
                                      noValue = 0;
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    width: contentsWidth * 0.48,
                                    decoration: BoxDecoration(
                                        color: okValue == 1
                                            ? const Color(0x3313C925)
                                            : const Color(0xFFF4F4F4),
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          color: okValue == 1
                                              ? const Color(0xFF10AA1F)
                                              : const Color(0xFF767676),
                                          Icons.sentiment_satisfied_alt,
                                          size: 24,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text('방문 성공',
                                            style: okValue == 1
                                                ? const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600)
                                                : const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF767676),
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                      ],
                                    ),
                                  ),
                                ),
                                // 방문 실패 버튼
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      okValue = 0;
                                      noValue = 1;
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    width: contentsWidth * 0.48,
                                    decoration: BoxDecoration(
                                        color: noValue == 1
                                            ? const Color(0x33C91E13)
                                            : const Color(0xFFF4F4F4),
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          size: 24,
                                          color: noValue == 1
                                              ? const Color(0xFFAD271F)
                                              : const Color(0xFF767676),
                                          Icons.sentiment_dissatisfied_outlined,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text('방문 실패',
                                            style: noValue == 1
                                                ? const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600)
                                                : const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF767676),
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 44,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        (okValue == 1 || noValue == 1)
                                            ? _checkDistance()
                                            : null;
                                      },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  splashFactory: (okValue == 0 && noValue == 0)
                                      ? NoSplash.splashFactory
                                      : InkSplash.splashFactory,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  backgroundColor:
                                      (okValue == 1 || noValue == 1)
                                          ? const Color(0xffF15A2B)
                                          : const Color(0xFFF4F4F4),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        '방문 인증',
                                        style: TextStyle(
                                          color:
                                              ((okValue == 1 || noValue == 1) &&
                                                      !isLoading)
                                                  ? Colors.white
                                                  : const Color(0xFF767676),
                                          fontWeight:
                                              ((okValue == 1 || noValue == 1) &&
                                                      !isLoading)
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                        ),
                                      ),
                              ),
                            )
                          ]),
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

  Future<void> _setMyMarkerAndStoreMarker() async {
    // 내위치로 화면 이동
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final myLocation = NLatLng(position.latitude, position.longitude);
      final storeLocation = NLatLng(
          manager.selectedDetail!.latitude, manager.selectedDetail!.longitude);

      //내위치 마커 추가
      NMarker myLocationMarker = NMarker(
        id: "my_location_marker",
        position: myLocation,
        icon:
            const NOverlayImage.fromAssetImage('assets/icons/my_location.png'),
      );

      //가게 마커도 추가
      NMarker storeLocationMarker = NMarker(
        id: "store_location_marker",
        position: storeLocation,
        icon: const NOverlayImage.fromAssetImage(
            'assets/icons/clicked_marker.png'),
      );

      //가게 기준 100m 반경 원 추가
      NCircleOverlay circleOverlay = NCircleOverlay(
        id: 'circleOverlay',
        center: storeLocation,
        radius: 100,
        color: const Color(0xFF003ACE).withOpacity(0.1), // 투명한 파란색 원
        outlineWidth: 1,
        outlineColor: const Color(0xFF003ACE),
      );

      myLocationMarker.setSize(const Size(24, 24));
      mapController.addOverlay(myLocationMarker);
      mapController.addOverlay(circleOverlay);

      storeLocationMarker.setSize(const Size(24, 24));
      mapController.addOverlay(storeLocationMarker);
    } catch (e) {
      // 에러 발생 시 로그 출력
      logger.d("Error in _moveToCurrentLocation: $e");
    }
  }

  void _checkDistance() async {
    if (isLoading || !mounted) {
      return;
    }
    setState(() {
      isLoading = true; // 버튼 비활성화
    });

    Position myPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //int로 형변환
    int checkMeter = Geolocator.distanceBetween(
            manager.selectedDetail!.latitude,
            manager.selectedDetail!.longitude,
            myPosition.latitude,
            myPosition.longitude)
        .floor();

    logger.d('두 개의 거리 차이는 = $checkMeter M');
    //만약 사용자와 가게 거리가 100미터 이내이면 방문인증 시작
    if (checkMeter <= 100) {
      _checkBangMoon(myPosition);
      logger.d('_checkBangMoon실행');
    }
    //아니라면 100미터 이내에 와야된다 하고 경고 후 내위치 보여주기
    else {
      setState(() {
        isLoading = false;
      });
      showFailDialog();
    }
  }

  void _checkBangMoon(Position myPosition) async {
    //서버 통신
    bool setTrueFaileValue;
    if (okValue == 1) {
      setTrueFaileValue = true;
    } else {
      setTrueFaileValue = false;
    }

    final accessToken = await storage.read(key: 'accessToken');

    final data = {
      "latitude": myPosition.latitude, // '방문인증'을 지도에서 누른 기준 사용자의 위도
      "longitude": myPosition.longitude, // '방문인증'을 지도에서 누른 기준 사용자의 경도
      "storeId": manager.selectedDetail!.id, // 방문인증 하고자 하는 점포의 id
      "isVisitSuccessful": setTrueFaileValue // 방문인증 성공 여부 ? true : false
    };

    final url = Uri.parse('$serverUrl/api/store/visit-cert');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        logger.d('성공 보낸 데이터: $data');
        setState(() {
          isLoading = false;
        });
        showSuccessDialog();
      } else {
        final errorData = utf8.decode(response.bodyBytes);
        logger.d('전송 실패 ${response.statusCode} 에러 내용 : $errorData ');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      logger.d('Error $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void showFailDialog() {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "방문 실패!",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "가게와의 거리가 너무 멀어요!",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Center(child: okButton),
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showSuccessDialog() {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        // 페이지 전환
        Navigator.popAndPushNamed(
          context,
          '/storeInfo',
          arguments: manager.selectedDetail!.id, // index 값을 전달
        );
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "방문 인증이 완료되었어요!",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "24시간 동안\n리뷰 작성과 가게 신고가 가능해요",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Center(child: okButton),
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // showAlertDialog(BuildContext context, int okValue, int noValue) {
  //   // set up the button
  //   Widget okButton = TextButton(
  //     child: const Text("OK"),
  //     onPressed: () {
  //       // 해당가게로 다시 돌아가기
  //       logger.d('하이');
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //     },
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: const Text("방문 인증"),
  //     content: const Text("방문 인증이 완료되었습니다. "),
  //     actions: [
  //       okButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
