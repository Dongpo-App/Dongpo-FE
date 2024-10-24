import 'dart:convert';

import 'package:dongpo_test/screens/login/login_view_model.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:dongpo_test/screens/main/main_03/main_03.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dongpo_test/main.dart';
import 'package:http/http.dart' as http;

class BangMoon extends StatelessWidget {
  const BangMoon({super.key});

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 좌우 마진 제외
    final contentsWidth = screenWidth - 48;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '방문에 성공하셨나요?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
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
                  color: Color(0x3313C925),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                      size: 24,
                      color: Color(0xFF10AA1F),
                      Icons.sentiment_satisfied_alt),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '방문 성공 ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${storeData?.visitSuccessfulCount ?? 0} 회',
                    style: TextStyle(
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
                  color: Color(0x33C91E13),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    color: Color(0xFFAD271F),
                    Icons.sentiment_dissatisfied_outlined,
                    size: 24,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '방문 실패 ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${storeData?.visitFailCount ?? 0} 회',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          height: 44,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const BangMoonPage()));
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              backgroundColor: const Color(0xffF15A2B),
            ),
            child: const Text(
              '방문 인증 하러가기',
              style: TextStyle(
                  fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        )
      ]
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
  late NaverMapController _mapController;
  int okValue = 0;
  int noValue = 0;

  @override
  //초기화
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 좌우 마진 제외
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
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                NaverMap(
                  onMapReady: (controller) {
                    _onMapReady(controller);
                    _SetMyMarkerAndStoreMarker();
                  },
                  options: const NaverMapViewOptions(
                    zoomGesturesEnable: false,
                    minZoom: 16,
                    scrollGesturesEnable: false,
                  ),
                ),
                SizedBox(
                  height: screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 8,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(4),
                            foregroundColor: Color(0xFF003ACE),
                            backgroundColor: WidgetStateColor.resolveWith(
                                (states) => Colors.white)),
                        onPressed: _checkDistance,
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        '가게 방문 인증',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
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
                                  ? Color(0x3313C925)
                                  : Color(0xFFF4F4F4),
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                color: okValue == 1
                                    ? Color(0xFF10AA1F)
                                    : Color(0xFF767676),
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
                                  ? Color(0x33C91E13)
                                  : Color(0xFFF4F4F4),
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                size: 24,
                                color: noValue == 1
                                    ? Color(0xFFAD271F)
                                    : Color(0xFF767676),
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
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 44,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        backgroundColor: (okValue == 1 || noValue == 1)
                            ? const Color(0xffF15A2B)
                            : const Color(0xFFF4F4F4),
                      ),
                      child: Text(
                        '방문 인증',
                        style: TextStyle(
                          color: (okValue == 1 || noValue == 1)
                              ? Colors.white
                              : Color(0xFF767676),
                          fontWeight: (okValue == 1 || noValue == 1)
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
  }

  Future<void> _SetMyMarkerAndStoreMarker() async {
    //내위치로 화면 이동
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final myLocation = NLatLng(position.latitude, position.longitude);
      final storeLocation = NLatLng(storeData!.latitude, storeData!.longitude);

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
        icon:
            const NOverlayImage.fromAssetImage('assets/icons/my_location.png'),
      );

      //가게 기준 500m 반경 원 추가
      NCircleOverlay circleOverlay = NCircleOverlay(
        id: 'circleOverlay',
        center: storeLocation,
        radius: 100,
        color: Colors.blue.withOpacity(0.3), // 투명한 파란색 원
        outlineWidth: 2,
        outlineColor: Colors.blue,
      );

      myLocationMarker.setSize(const Size(40, 50));
      _mapController.addOverlay(myLocationMarker);
      _mapController.addOverlay(circleOverlay);

      storeLocationMarker.setSize(const Size(40, 50));
      _mapController.addOverlay(storeLocationMarker);

      _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: myLocation,
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      // 에러 발생 시 로그 출력
      logger.d("Error in _moveToCurrentLocation: $e");
    }
  }

  void _checkDistance() async {
    Position myPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //int로 형변환
    int checkMeter = Geolocator.distanceBetween(storeData!.latitude,
            storeData!.longitude, myPosition.latitude, myPosition.longitude)
        .floor();

    logger.d('두 개의 거리 차이는 = $checkMeter M');
    //만약 사용자와 가게 거리가 100미터 이내이면 방문인증 시작
    if (checkMeter <= 100) {
      _checkBangMoon(myPosition);
      logger.d('_checkBangMoon실행');
    }
    //아니라면 100미터 이내에 와야된다하고 경고 후 내위치 보여주기
    else {
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
      "storeId": storeData!.id, // 방문인증 하고자 하는 점포의 id
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
        showSuccessDialog();
      } else {
        final errorData = utf8.decode(response.bodyBytes);
        logger.d('전송 실패 ${response.statusCode} 에러 내용 : $errorData ');

        //실패했을 떄
      }
    } catch (e) {
      logger.d('Error $e');
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()), // 1페이지로 이동
          (Route<dynamic> route) => false, // 모든 이전 스택을 삭제
        );

        // 1페이지로 이동 후 바로 2페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoreInfo(
                    idx: storeData!.id,
                  )), // 2페이지로 이동
        );
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "인증 성공!",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "방문 인증이 완료되었어요!",
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
