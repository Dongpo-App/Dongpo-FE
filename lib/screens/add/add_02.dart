import 'dart:convert';
import 'package:dongpo_test/widgets/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:http/http.dart' as http;
import 'package:dongpo_test/screens/add/add_01.dart';
import 'package:dongpo_test/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GageAddSangsea extends StatefulWidget {
  const GageAddSangsea({super.key});

  @override
  State<GageAddSangsea> createState() => _GageAddSangseaState();
}

class _GageAddSangseaState extends State<GageAddSangsea> {
  static final storage = FlutterSecureStorage();

  String openTime = '00:00';
  String closeTime = '00:00';
  int bathSelected = 0; //화장실 라디오 버튼
  List<bool> _selectedDays = [false, false, false, false, false, false, false];
  List<bool> _selectedPaymentMethods = [false, false, false];
  //버튼 활성화 비활성화를 위한 value값
  int value = 0;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      _onTextFieldChanged();
    });
  }

  void _onTextFieldChanged() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        value = 1;
      });
    } else if (_nameController.text.isEmpty) {
      setState(() {
        value = 0;
      });
    } else
      return null;
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextFieldChanged);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '가게 등록',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyAppPage();
                }));
              },
              icon: Icon(CupertinoIcons.xmark))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: ListView(
          children: [
            //가게 위치 *
            Row(
              children: [
                Text(
                  '가게 위치',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '*',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            //가게위치 검색바
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //검색바 안에 주소
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    Text(
                      '${dataForm.sendAddress}',
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                    ),
                    Spacer(),
                    Icon(CupertinoIcons.right_chevron),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //가게 이름 *
            Row(
              children: [
                Text(
                  '가게 이름',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '*',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                left: 16,
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '가게 이름을 입력해주세요.',
                  border: InputBorder.none, // 밑줄 제거
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),

            // 오픈 요일
            Row(
              children: [
                Text(
                  '오픈요일',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '여러 개 선택 가능해요!',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (index) {
                return GestureDetector(
                  onTap: () => _onDayTapped(index),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedDays[index]
                          ? Color(0xffF15A2B)
                          : Colors.grey[300],
                    ),
                    width: 32.0,
                    height: 48.0,
                    child: Center(
                      child: Text(
                        ['일', '월', '화', '수', '목', '금', '토'][index],
                        style: TextStyle(
                          color: _selectedDays[index]
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 30,
            ),

            // 오픈시간
            Row(
              children: [
                Text(
                  '오픈 시간',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),

            //오픈시간 시간설정
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        picker.DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            openTime = "${date.hour}:${date.minute}";
                          });
                        }, currentTime: DateTime.now());
                      },
                      //openTime Container
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          '$openTime',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    " ~ ",
                    style: TextStyle(fontSize: 25),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        picker.DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            closeTime = "${date.hour}:${date.minute}";
                          });
                        }, currentTime: DateTime.now());
                      },
                      //closeTime Container
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          '$closeTime',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),

            //결제 방식
            Row(
              children: [
                Text(
                  '결제 방식',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '여러 개 선택 가능해요!',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: () => _onPaymentMethodTapped(index),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: _selectedPaymentMethods[index]
                          ? Color(0xffF15A2B)
                          : Colors.grey[300],
                    ),
                    width: 96.0,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        ['현금', '계좌이체', '카드'][index],
                        style: TextStyle(
                          color: _selectedPaymentMethods[index]
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(
              height: 30,
            ),
            //화장실
            Row(
              children: [
                Text(
                  '화장실',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: _bathSelected('있음', 1)),
                SizedBox(width: 30),
                Expanded(child: _bathSelected('없음 ', 2)),
              ],
            ),
            //가게 등록버튼

            SizedBox(
              height: 30,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  splashFactory: (value == 0)
                      ? NoSplash.splashFactory
                      : InkSplash.splashFactory,
                  //모두 동의했을 경우 버튼 활성화
                  backgroundColor:
                      (value == 1) ? Color(0xffF15A2B) : Colors.grey[300],
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                //가게 등록 로직 구현
                (value == 0) ? null : sendData();
              },
              child: Text(
                '가게등록',
                style: TextStyle(
                    color: (value == 1) ? Colors.white : Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //오픈 요일
  void _onDayTapped(int index) {
    setState(() {
      _selectedDays[index] = !_selectedDays[index];
    });
  }

  List<String> _getSelectedDays() {
    final List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    List<String> selectedDays = [];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) {
        selectedDays.add(days[i]);
      }
    }
    return selectedDays;
  }

  //결제 방식
  void _onPaymentMethodTapped(int index) {
    setState(() {
      _selectedPaymentMethods[index] = !_selectedPaymentMethods[index];
    });
  }

  List<String> _getSelectedPaymentMethods() {
    final List<String> paymentMethods = ['CASH', 'CARD', 'TRANSFER'];
    List<String> selectedMethods = [];
    for (int i = 0; i < _selectedPaymentMethods.length; i++) {
      if (_selectedPaymentMethods[i]) {
        selectedMethods.add(paymentMethods[i]);
      }
    }
    return selectedMethods;
  }

  Future<void> sendData() async {
    final accessToken = await storage.read(key: 'accessToken');
    double value1 = dataForm.sendLatitude;
    double value2 = dataForm.sendLongitude;

    double truncatedValue1 = (value1 * 1000000).truncateToDouble() / 1000000;
    double truncatedValue2 = (value2 * 1000000).truncateToDouble() / 1000000;

    logger.d("$truncatedValue1 || $truncatedValue2");
    final data = {
      'name': _nameController.text,
      'address': dataForm.sendAddress,
      'latitude': truncatedValue1, //latitude
      'longitude': truncatedValue2, //longitude
      'openTime': openTime,
      'closeTime': closeTime,
      'isToiletValid': bathSelected == 1,
      'operatingDays': _getSelectedDays(),
      'payMethods': _getSelectedPaymentMethods(),
    };

    final url = Uri.parse('https://1417mhz.xyz/api/store');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        logger.d('성공 보낸 데이터: $data');
        showAlertDialog(context);
      } else {
        logger.d('전송 실패 ${response.statusCode} 에러');
        //실패했을 떄
      }
    } catch (e) {
      logger.d('Error $e');
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Color(0xffF15A2B)),
      child: Text(
        "확인",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyAppPage()));
      },
    );

    // set up the AlertDialog
    // 완료되었을 때 Alert
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text("등록 성공!"),
      content: Text("가게가 성공적으로 등록 완료되었어요!"),
      actions: [
        Center(child: okButton),
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //화장실 라디오버튼
  Widget _bathSelected(String text, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor:
              bathSelected == index ? Color(0xffF15A2B) : Colors.grey[300]),
      onPressed: () {
        setState(() {
          bathSelected = index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
            color: bathSelected == index ? Colors.white : Colors.grey[700]),
      ),
    );
  }
}
