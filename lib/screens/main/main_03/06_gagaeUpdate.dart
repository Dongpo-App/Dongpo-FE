import 'dart:convert';
import 'package:dongpo_test/widgets/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:http/http.dart' as http;

import 'package:dongpo_test/main.dart';

class GagaeUpdate extends StatefulWidget {
  const GagaeUpdate({super.key});

  @override
  State<GagaeUpdate> createState() => _GagaeUpdateState();
}

class _GagaeUpdateState extends State<GagaeUpdate> {
  String openTime = '00:00';
  String closeTime = '00:00';
  int bathSelected = 0; //화장실 라디오 버튼
  final List<bool> _selectedDays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final List<bool> _selectedPaymentMethods = [false, false, false];
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
      return;
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextFieldChanged);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 좌우 마진 제외
    final contentsWidth = screenWidth - 48;

    return GestureDetector(
      onTap: () {
        // TextField 외부를 터치했을 때 키보드 내려감
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            "가게 정보 수정하기",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(
                height: 24,
              ),
              //가게 위치 *
              const Row(
                children: [
                  Text(
                    "가게 위치",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "*",
                    style: TextStyle(
                      color: Color(0xFFF15A2B),
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              //가게위치 검색바
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  //검색바 안에 주소
                  child: const Row(
                    children: <Widget>[
                      SizedBox(width: 24.0),
                      Text(
                        '주소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF767676),
                        ),
                      ),
                      Spacer(),
                      Icon(
                        size: 16,
                        CupertinoIcons.right_chevron
                      ),
                      SizedBox(width: 24.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              //가게 이름 *
              const Row(
                children: [
                  Text(
                    '가게 이름',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '*',
                    style: TextStyle(
                      color: Color(0xFFF15A2B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 44,
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 24,
                ),
                decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF767676),
                  ),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: '가게 이름을 입력해주세요.',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF767676),
                    ),
                    border: InputBorder.none, // 밑줄 제거
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
      
              // 오픈 요일
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '오픈요일',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '여러 개 선택 가능해요!',
                    style: TextStyle(
                      color: Color(0xFF767676),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  return GestureDetector(
                    onTap: () => _onDayTapped(index),
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedDays[index]
                            ? const Color(0xffF15A2B)
                            : const Color(0xFFF4F4F4),
                      ),
                      width: contentsWidth * 0.118,
                      height: contentsWidth * 0.118,
                      child: Center(
                        child: Text(
                          ['일', '월', '화', '수', '목', '금', '토'][index],
                          style: TextStyle(
                            color: _selectedDays[index]
                              ? Colors.white
                              : const Color(0xFF767676),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 40,
              ),
      
              // 오픈시간
              const Row(
                children: [
                  Text(
                    '오픈 시간',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              //오픈시간 시간설정
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        height: 44,
                        width: contentsWidth * 0.4,
                        padding: const EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          openTime,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767676),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    " ~ ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF767676),
                    ),
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
                        height: 44,
                        width: contentsWidth * 0.4,
                        padding: const EdgeInsets.only(left: 24),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          closeTime,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767676),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              //결제 방식
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '결제 방식',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '여러 개 선택 가능해요!',
                    style: TextStyle(
                      color: Color(0xFF767676),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () => _onPaymentMethodTapped(index),
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: _selectedPaymentMethods[index]
                          ? const Color(0xffF15A2B)
                          : const Color(0xFFF4F4F4),
                      ),
                      width: contentsWidth * 0.3,
                      height: 44.0,
                      child: Center(
                        child: Text(
                          ['현금', '계좌이체', '카드'][index],
                          style: TextStyle(
                            color: _selectedPaymentMethods[index]
                              ? Colors.white
                              : const Color(0xFF767676),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
      
              const SizedBox(
                height: 40,
              ),
              //화장실
              const Row(
                children: [
                  Text(
                    '화장실',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 44,
                    width: contentsWidth * 0.48,
                    child: _bathSelected('있음', 1)
                  ),
                  SizedBox(
                    height: 44,
                    width: contentsWidth * 0.48,
                    child: _bathSelected('없음 ', 2)
                  ),
                ],
              ),
              //가게 등록버튼
      
              const SizedBox(
                height: 40,
              ),
      
              SizedBox(
                height: 44,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    splashFactory: (value == 0)
                      ? NoSplash.splashFactory
                      : InkSplash.splashFactory,
                    //모두 동의했을 경우 버튼 활성화
                    backgroundColor: (value == 1)
                      ? const Color(0xffF15A2B)
                      : const Color(0xFFF4F4F4),
                    minimumSize: const Size(double.infinity, 44),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
                  onPressed: () {
                    //가게 등록 로직 구현
                    (value == 0) ? null : sendData();
                  },
                  child: Text(
                    '가게 수정',
                    style: TextStyle(
                      color: (value == 1)
                        ? Colors.white
                        : const Color(0xFF767676)
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
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
    final data = {
      'name': _nameController.text,
      'address': '',
      'latitude': '', //latitude
      'longitude': '', //longitude
      'openTime': openTime,
      'closeTime': closeTime,
      'isToiletValid': bathSelected == 1,
      'operatingDays': _getSelectedDays(),
      'payMethods': _getSelectedPaymentMethods(),
    };

    final url = Uri.parse('https://dongpo-api-server.xyz');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(data);

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
      logger.d(data);
      //실패했을 떄
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyAppPage()));
      },
    );

    // set up the AlertDialog
    // 완료되었을 때 Alert
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("수정 성공!"),
      content: const Text("가게정보 수정이 완료되었습니다!."),
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
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        backgroundColor: bathSelected == index
          ? const Color(0xffF15A2B)
          : const Color(0xFFF4F4F4),
      ),
      onPressed: () {
        setState(() {
          bathSelected = index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: bathSelected == index ? Colors.white : const Color(0xFF767676)
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
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
