import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dongpo_test/main.dart';

late NaverMapController _mapController;
void main() async {
  await reset_map();
  runApp(MyApp());
}

int okValue = 0;
int noValue = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SecondPage(),
      ),
    );
  }
}

class BangMoon extends StatelessWidget {
  const BangMoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '방문에 성공하셨나요?',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //방문 성공 컨테이너
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: [
                Icon(color: Colors.green[700], Icons.sentiment_satisfied_alt),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '방문 성공 A명',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
          //방문 실패 컨테이너
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            decoration: BoxDecoration(
                color: Colors.red[200],
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: [
                Icon(
                  color: Colors.red[800],
                  Icons.sentiment_dissatisfied_outlined,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('방문 실패 A명', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ],
      ),
      Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SecondPage()));
          },
          child: Text(
            '방문 인증 하러가기',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            minimumSize: Size(double.infinity, 40),
            backgroundColor: Color(0xffF15A2B),
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
  @override
  //초기화
  void initState() {
    super.initState();
    _moveToCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('가게 방문 인증 '),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: NaverMap(
              onMapReady: (controller) {
                _onMapReady(controller);
              },
              options: NaverMapViewOptions(
                zoomGesturesEnable: false,
                minZoom: 16,
                scrollGesturesEnable: false,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 23,
                      ),
                      Text(
                        '가게 방문 인증',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          decoration: BoxDecoration(
                              color: okValue == 1
                                  ? Colors.green[200]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            children: [
                              Icon(
                                  color: okValue == 1
                                      ? Colors.green[700]
                                      : Colors.grey,
                                  Icons.sentiment_satisfied_alt),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '방문 성공',
                                style: okValue == 1
                                    ? TextStyle(fontWeight: FontWeight.bold)
                                    : null,
                              ),
                              SizedBox(
                                width: 20,
                              )
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
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          decoration: BoxDecoration(
                              color: noValue == 1
                                  ? Colors.red[200]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            children: [
                              Icon(
                                color: noValue == 1
                                    ? Colors.red[800]
                                    : Colors.grey,
                                Icons.sentiment_dissatisfied_outlined,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('방문 실패',
                                  style: noValue == 1
                                      ? TextStyle(fontWeight: FontWeight.bold)
                                      : null),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        (okValue == 1 || noValue == 1)
                            ? showAlertDialog(context, okValue, noValue)
                            : null;

                        //방문 인증 메서드 구현
                      },
                      child: Text(
                        '방문인증',
                        style: TextStyle(
                            color: (okValue == 1 || noValue == 1)
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        splashFactory: (okValue == 0 && noValue == 0)
                            ? NoSplash.splashFactory
                            : InkSplash.splashFactory,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        minimumSize: Size(double.infinity, 40),
                        backgroundColor: (okValue == 1 || noValue == 1)
                            ? Color(0xffF15A2B)
                            : Colors.grey[100],
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
}

void _onMapReady(NaverMapController controller) {
  _mapController = controller;
}

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
  } catch (e) {
    // 에러 발생 시 로그 출력
    logger.d("Error in _moveToCurrentLocation: $e");
  }
}

showAlertDialog(BuildContext context, int okValue, int noValue) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      logger.d('하이');
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("방문 인증"),
    content: Text("방문 인증이 완료되었습니다. "),
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
