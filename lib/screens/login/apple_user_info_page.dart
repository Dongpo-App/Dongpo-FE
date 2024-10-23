import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/login_response.dart';
import 'package:dongpo_test/models/request/apple_signup_request.dart';
import 'package:dongpo_test/service/login_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../widgets/bottom_navigation_bar.dart';
import 'apple_kakao_naver_login.dart';
import 'login_view_model.dart';

class AppleUserInfoPage extends StatefulWidget {
  const AppleUserInfoPage({
    this.userData,
    super.key,
  });
  final Map<String, dynamic>? userData; // socialId 와 email 들어있음

  @override
  State<AppleUserInfoPage> createState() => AppleUserInfoPageState();
}

class AppleUserInfoPageState extends State<AppleUserInfoPage> {
  final viewModel = LoginViewModel(AppleKakaoNaverLogin());
  LoginApiService loginService = LoginApiService.instance;

  // 이메일 컨트롤러
  final TextEditingController _emailController =
      TextEditingController(text: "");
  String? socialId;
  String? email;
  bool isEmailNull = false;

  // 닉네임 입력 관련
  final TextEditingController _nickNameController =
      TextEditingController(text: "");
  String nickName = "";

  // 생년월일 입력 관련
  final TextEditingController _birthdayController =
      TextEditingController(text: "");
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();

  // 성별 선택 관련
  String? selectedGender;

  // 버튼 활성화
  bool emailUpdateValue = false;
  bool nickUpdateValue = false;
  bool birthdayUpdateValue = false;
  bool genderUpdateValue = false;

  // 회원가입 API 결과
  String signUp = "";

  @override
  initState() {
    super.initState();
    // socialId, email
    socialId = widget.userData!['socialId'];
    email = widget.userData!['email'];
    isEmailNull = email == null;
    logger.d("email: $email, socialId: $socialId, isEmailExists: $isEmailNull");
  }

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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Image.asset(
                      'assets/images/login.png',
                      width: screenWidth, // 전체 너비 사용
                      fit: BoxFit.cover, // 이미지를 잘라내지 않고 채움
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.06,
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
                  height: screenHeight * 0.06,
                ),
                // 이메일 필드
                Visibility(
                  visible: isEmailNull,
                  child: GestureDetector(
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
                                "이메일",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w600),
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
                                borderRadius: BorderRadius.circular(12)),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (text) {
                                if (mounted) {
                                  setState(() {
                                    // 이메일 유효성 검사
                                    RegExp emailRegex = RegExp(
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                    if (emailRegex.hasMatch(text)) {
                                      email = text;
                                      emailUpdateValue = true;
                                    } else {
                                      emailUpdateValue = false;
                                    }
                                  });
                                }
                              },
                              controller: _emailController,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFF4F4F4),
                                  fontWeight: FontWeight.w400),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'example@dongpo.com',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF33393F),
                                ),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // 닉네임
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
                                  fontWeight: FontWeight.w600),
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
                              borderRadius: BorderRadius.circular(12)),
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
                                fontWeight: FontWeight.w400),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '7글자까지 입력 가능해요',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF33393F),
                              ),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // 생년월일
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
                            padding: EdgeInsets.only(
                              left: 24.0,
                            ),
                            child: Text(
                              "생년월일",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600),
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
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0), // 세로 패딩 설정
                            ),
                            controller: _birthdayController,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFFF4F4F4),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // 성별
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
                            padding: EdgeInsets.only(
                              left: 24.0,
                            ),
                            child: Text(
                              "성별",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600),
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
                                  selectedGender = 'GEN_MALE'; // 남성 선택
                                  genderUpdateValue = true;
                                });
                              },
                              child: Container(
                                height: 44,
                                width: contentsWidth * 0.48,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: selectedGender == 'GEN_MALE'
                                      ? const Color(0xFFF15A2B) // 선택된 색상
                                      : const Color(0xFF57616A), // 기본 색상
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "남",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedGender == 'GEN_MALE'
                                          ? Colors.white
                                          : const Color(0xFF33393F),
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
                                  selectedGender = 'GEN_FEMALE'; // 여성 선택
                                  genderUpdateValue = true;
                                });
                              },
                              child: Container(
                                height: 44,
                                width: contentsWidth * 0.48,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: selectedGender == 'GEN_FEMALE'
                                      ? const Color(0xFFF15A2B) // 선택된 색상
                                      : const Color(0xFF57616A), // 기본 색상
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "여",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedGender == 'GEN_FEMALE'
                                          ? Colors.white
                                          : const Color(0xFF33393F),
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
                const SizedBox(height: 36),
                // 가입 버튼
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, // 그림자 제거
                        splashFactory: (nickUpdateValue &
                                birthdayUpdateValue &
                                genderUpdateValue &
                                emailUpdateValue)
                            ? NoSplash.splashFactory
                            : InkSplash.splashFactory,
                        // 수정이 있을 경우 버튼 활성화
                        backgroundColor: (nickUpdateValue &
                                birthdayUpdateValue &
                                genderUpdateValue &
                                emailUpdateValue)
                            ? const Color(0xffF15A2B)
                            : const Color(0xFF57616A),
                        minimumSize: const Size(double.infinity, 40),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0)))),
                    onPressed: () async {
                      if (nickUpdateValue &
                          birthdayUpdateValue &
                          genderUpdateValue &
                          emailUpdateValue) {
                        AppleSignupRequest request = AppleSignupRequest(
                          nickname: nickName,
                          birthday: _birthdayController.text,
                          gender: selectedGender!,
                          socialId: socialId!,
                          email: email!,
                        );
                        logger.d("data: ${request.toString()}");
                        LoginResponse response =
                            await loginService.appleSignup(request);
                        if (response.statusCode == 200) {
                          if (mounted) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyAppPage()));
                          } else if (response.statusCode == 409) {
                            httpStatusCode409();
                          }
                        }
                        // signUp = await viewModel.appleSignUpPostAPI(
                        //     context,
                        //     nickName,
                        //     _birthdayController.text,
                        //     selectedGender!);
                        // logger.d("apple sign up : $signUp");

                        // if (signUp == "200") {
                        //   // 서버에서 발급받은 토큰을 FlutterSecureStorage에 저장
                        //   await storage.write(
                        //       key: 'accessToken', value: viewModel.accessToken);
                        //   await storage.write(
                        //       key: 'refreshToken',
                        //       value: viewModel.refreshToken);
                        //   await storage.write(
                        //       key: 'loginPlatform',
                        //       value: viewModel.loginPlatform.name);
                        //   Map<String, String> allData = await storage.readAll();
                        //   logger.d("secure storage apple read : $allData");

                        //   Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const MyAppPage()),
                        //     (route) => false,
                        //   );
                        // }
                      } else if (signUp == "409") {
                        httpStatusCode409();
                      }
                    },
                    child: Text(
                      '가입',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: (nickUpdateValue &
                                  birthdayUpdateValue &
                                  genderUpdateValue &
                                  emailUpdateValue)
                              ? Colors.white
                              : const Color(0xFF33393F)),
                    ),
                  ),
                ),
              ],
            ),
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

  void httpStatusCode409() {
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
        "로그인 실패",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "이미 등록된 이메일이에요",
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
}
