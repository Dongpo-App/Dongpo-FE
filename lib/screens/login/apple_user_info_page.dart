import 'package:dongpo_test/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppleUserInfoPage extends StatefulWidget {
  const AppleUserInfoPage({super.key});

  @override
  State<AppleUserInfoPage> createState() => AppleUserInfoPageState();
}

class AppleUserInfoPageState extends State<AppleUserInfoPage> {
  // 닉네임 입력 관련
  final TextEditingController _nickNameController = TextEditingController(text: "");
  String nickName = "";

  // 생년월일 입력 관련
  final TextEditingController _birthdayController = TextEditingController(text: "");
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();

  // 성별 선택 관련
  String? selectedGender;

  // 버튼 활성화
  bool nickUpdateValue = false;
  bool birthdayUpdateValue = false;
  bool genderUpdateValue = false;

  @override
  void dispose() {
    _nickNameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 전체 화면 높이
    final screenHeight = MediaQuery.of(context).size.height;
    // 좌우 마진 제외
    final contentsWidth = screenWidth - 48;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF33393F),
        body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/login.png'),
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Text(
                    "동포 회원가입",
                    style: TextStyle(
                      fontFamily: 'Chosun',
                      color: Color(0xFFFFFFFF),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact(); // 터치 시 진동 효과 제공
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 24.0),
                            child: Text(
                              "닉네임",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600
                              ),
                            ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Container(
                          height: 44,
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            left: 16,
                          ),
                          decoration: BoxDecoration(
                              color: const Color(0xFF57616A),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) {
                              if (mounted) {
                                setState(() {
                                  if (text.length <= 7 && text.isNotEmpty) {
                                    nickName = text;
                                    nickUpdateValue = true;
                                  } else {
                                    nickUpdateValue = false;
                                  }
                                });
                              }
                            },
                            controller: _nickNameController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFF4F4F4),
                              fontWeight: FontWeight.w400
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '7글자까지 입력 가능해요',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF33393F),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32,),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact(); // 터치 시 진동 효과 제공
                    _selectDate(); // 바텀시트
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Padding(
                           padding: EdgeInsets.only(left: 24.0,),
                            child: Text(
                              "생년월일",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600
                              ),
                            ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Container(
                          height: 44,
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            left: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF57616A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                              hintText: '생년월일을 선택해 주세요',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF33393F),
                              ),
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0), // 세로 패딩 설정
                            ),
                            controller: _birthdayController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFF4F4F4),
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32,),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact(); // 터치 시 진동 효과 제공
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 24.0,),
                            child: Text(
                              "성별",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600
                              ),
                            ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact(); // 터치 시 진동 효과 제공
                                setState(() {
                                  selectedGender = '남'; // 남성 선택
                                  genderUpdateValue = true;
                                });
                              },
                              child: Container(
                                height: 44,
                                width: contentsWidth * 0.48,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: selectedGender == '남'
                                      ? const Color(0xFFF15A2B) // 선택된 색상
                                      : const Color(0xFF57616A), // 기본 색상
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "남",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedGender == '남' ? Colors.white : const Color(0xFF33393F),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact(); // 터치 시 진동 효과 제공
                                setState(() {
                                  selectedGender = '여'; // 여성 선택
                                  genderUpdateValue = true;
                                });
                              },
                              child: Container(
                                height: 44,
                                width: contentsWidth * 0.48,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: selectedGender == '여'
                                    ? const Color(0xFFF15A2B) // 선택된 색상
                                    : const Color(0xFF57616A), // 기본 색상
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "여",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedGender == '여' ? Colors.white : const Color(0xFF33393F),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0, // 그림자 제거
                        splashFactory: (nickUpdateValue & birthdayUpdateValue & genderUpdateValue)
                          ? NoSplash.splashFactory
                          : InkSplash.splashFactory,
                        // 수정이 있을 경우 버튼 활성화
                        backgroundColor: (nickUpdateValue & birthdayUpdateValue & genderUpdateValue)
                          ? const Color(0xffF15A2B)
                          : const Color(0xFF57616A),
                        minimumSize: const Size(double.infinity, 40),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))
                        )
                      ),
                      onPressed: () async {
                        if (nickUpdateValue & birthdayUpdateValue & genderUpdateValue) {
                          logger.d("닉네임 : $nickName / 생년월일 : ${_birthdayController.text} / 성별 : $selectedGender");
                        } else {
                          return;
                        }
                        // userProfileUpdate = await viewModel.userProfileUpdateAPI(context, sendData, nickname, mainTitle);
                        // logger.d("profile update : $userProfileUpdate");
                  
                        //if (userProfileUpdate) {
                          // 상태 업데이트를 제거하고 바로 네비게이션 수행
                          //Navigator.pushAndRemoveUntil(
                            //context,
                            //MaterialPageRoute(
                                //builder: (context) =>
                                //const MyAppPage(initialIndex: 3)),
                                //(route) => false,
                          //);
                        //}
                      },
                      child: Text(
                        '가입',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: (nickUpdateValue & birthdayUpdateValue & genderUpdateValue)
                            ? Colors.white
                            : const Color(0xFF33393F)
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        // DateTime tempPickedDate;
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        color: Color(0xFF33393F),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  CupertinoButton(
                    child: const Text(
                      '완료',
                      style: TextStyle(
                        color: Color(0xFF33393F),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(tempPickedDate);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: CupertinoDatePicker(
                  backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year,
                  initialDateTime: DateTime.now(),
                  maximumDate: DateTime.now(),
                  dateOrder: DatePickerDateOrder.ymd,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime dateTime) {
                    tempPickedDate = dateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthdayController.text = pickedDate.toString();
        birthdayUpdateValue = true;
        convertDateTimeDisplay(_birthdayController.text);
      });
    } else {
      birthdayUpdateValue = false;
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    return _birthdayController.text = serverFormater.format(displayDate);
  }
}
