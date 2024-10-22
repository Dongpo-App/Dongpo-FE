import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dongpo_test/main.dart';

class BangMoon extends StatelessWidget {
  const BangMoon({super.key});

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 좌우 마진 제외
    final contentsWidth = screenWidth - 48;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    builder: (BuildContext context) => const SecondPage()));
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
    ]);
  }
}

// 방문 인증 페이지
class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late NaverMapController _mapController;
  int okValue = 0;
  int noValue = 0;

  @override
  //초기화
  void initState() {
    super.initState();
    _moveToCurrentLocation();
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
            child: NaverMap(
              onMapReady: (controller) {
                _onMapReady(controller);
              },
              options: const NaverMapViewOptions(
                zoomGesturesEnable: false,
                minZoom: 16,
                scrollGesturesEnable: false,
              ),
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
                            ? showAlertDialog(context, okValue, noValue)
                            : null;

                        //방문 인증 메서드 구현
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

  Future<void> _moveToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final myLocation = NLatLng(position.latitude, position.longitude);

      const myLocationIcon =
          NOverlayImage.fromAssetImage('assets/images/myLocation.png');

      NMarker myLocationMarker = NMarker(
        id: "my_location_marker",
        position: myLocation,
        icon: myLocationIcon,
      );

      myLocationMarker.setSize(const Size(40, 50));
      _mapController.addOverlay(myLocationMarker);

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

  showAlertDialog(BuildContext context, int okValue, int noValue) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        logger.d('하이');
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("방문 인증"),
      content: const Text("방문 인증이 완료되었습니다. "),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
