import 'dart:io';

import 'package:dongpo_test/models/user_profile.dart';
import 'package:dongpo_test/screens/my_info/my_page_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/login/kakao_naver_login.dart';
import 'package:dongpo_test/screens/login/login.dart';
import 'package:dongpo_test/screens/login/login_view_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/bottom_navigation_bar.dart';
import '../../models/title.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // 로그아웃 관련
  final loginViewModel = LoginViewModel(KakaoNaverLogin());
  static final storage = FlutterSecureStorage();
  bool isLogouted = false;

  // 사용자 정보 관련
  MyPageViewModel viewModel = MyPageViewModel();
  late UserProfile _userProfile = UserProfile(nickname: "", profilePic: "", mainTitle: UserTitle(title: "", description: ""),
      titles: [], registerCount: 0, titleCount: 0, presentCount: 0);

  late final TextEditingController nicknameController;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  void dispose() {
    nicknameController.dispose();  // TextEditingController 해제
    super.dispose();  // 부모 클래스의 dispose 호출
  }

  void getUserProfile() async {
    _userProfile = await viewModel.userProfileGetAPI();
    setState(() {
    });
  }

  // 프로필 사진 수정 관련
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
        centerTitle: true,
        title: Text(
          "마이 페이지",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // 전체 화면 높이 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 48, left: 24, right: 24),
                color:  Color(0xFFFFFF),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 프로필 사진
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: (_userProfile.profilePic != null && _userProfile.profilePic!.isNotEmpty)
                          ? NetworkImage(_userProfile.profilePic!)
                              as ImageProvider
                          : AssetImage('assets/images/profile.jpg'),
                    ),
                    SizedBox(width: 16), // 간격 조정
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                        children: [
                          // 칭호
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5E0D9),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Color(0xFFF5E0D9), // 테두리 색상
                              ),
                            ),
                            child: Text(
                              _userProfile.mainTitle.description,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF15A2B),
                              ),
                            ),
                          ),
                          SizedBox(height: 8), // 간격 조정
                          // 닉네임
                          Text(
                            _userProfile.nickname,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // 간격 조정
              Container(
                height: 44,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24),
                // 프로필 편집 버튼
                child: OutlinedButton(
                  onPressed: () {
                    showEditProfileBottomSheet(context);
                  },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ))),
                  child: Text(
                    '프로필 편집',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF767676),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24), // 간격 조정
              // 등록한 가게, 칭호, 선물함
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 등록한 가게
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userProfile.registerCount.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767676),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '등록한 가게',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF767676),
                          ),
                        ),
                      ],
                    ),
                    // 칭호
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userProfile.titleCount.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767676),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '칭호',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF767676),
                          ),
                        ),
                      ],
                    ),
                    // Spacer(),
                    // 선물함
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       _userProfile.presentCount.toString(),
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w400,
                    //         color: Color(0xFF767676),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 8,
                    //     ),
                    //     Text(
                    //       '선물함',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600,
                    //         color: Color(0xFF767676),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F4F4),
                  ),
                ),
              ),
              // 내 칭호, 내가 쓴 리뷰, 북마크한 가게, 선물함
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text(
                    '내 칭호',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF767676)),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    // 내 칭호 버튼이 클릭되었을 때의 액션
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text(
                    '내가 쓴 리뷰',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF767676)),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    // 내가 쓴 리뷰 버튼이 클릭되었을 때의 액션
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text(
                    '북마크한 가게',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF767676)),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    // 북마크한 가게 버튼이 클릭되었을 때의 액션
                  },
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              //   child: ListTile(
              //     title: Text(
              //       '선물함',
              //       style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w400,
              //           color: Color(0xFF767676)),
              //     ),
              //     trailing: Icon(Icons.keyboard_arrow_right),
              //     onTap: () {
              //       // 선물함 버튼이 클릭되었을 때의 액션
              //     },
              //   ),
              // ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  color: Color(0xFFF4F4F4),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          String? loginPlatform =
                              await storage.read(key: 'loginPlatform');
                          if (loginPlatform == null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false, // 모든 이전 페이지 제거
                            );
                          }
                          isLogouted = await loginViewModel.logout(loginPlatform);
                          if (isLogouted) {
                            // FlutterSecureStorage에 있는 token 삭제
                            await storage.delete(key: 'accessToken');
                            await storage.delete(key: 'refreshToken');
                            await storage.delete(key: 'loginPlatform');

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false, // 모든 이전 페이지 제거
                            );
                          }
                        },
                        child: Text(
                          '로그아웃',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF767676),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          String? loginPlatform =
                              await storage.read(key: 'loginPlatform');
                          if (loginPlatform == null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false, // 모든 이전 페이지 제거
                            );
                          }
                          isLogouted = await loginViewModel.logout(loginPlatform);
                          if (isLogouted) {
                            // FlutterSecureStorage에 있는 token 삭제
                            await storage.delete(key: 'accessToken');
                            await storage.delete(key: 'refreshToken');
                            await storage.delete(key: 'loginPlatform');
                            Map<String, String> allData = await storage.readAll();
                            logger.d("logout token : ${allData}");
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false, // 모든 이전 페이지 제거
                            );
                          }
                        },
                        child: Text(
                          '탈퇴',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF767676),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showEditProfileBottomSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; // 현재 화면 높이
    final bottomSheetHeight = screenHeight * 0.45; // 화면 높이의 50%

    // TextEditingController를 사용하여 초기값 설정
    nicknameController = TextEditingController(text: _userProfile.nickname);
    String nickname = nicknameController.text;

    // 사용자가 닉네임 수정 입력을 완료하면 호출
    void _onEditingComplete() {
      setState(() {
        nickname = nicknameController.text;
      });
    }

    // userProfileUpdate 초기값 설정
    String userPic = (_userProfile.profilePic != null) ? _userProfile.profilePic! : 'assets/images/profile.jpg';

    // 사용자 사진 선택
    XFile? pickedFile;
    dynamic? sendData;

    // 사용자 정보 수정 상태 변수
    bool userProfileUpdate = false;

    //버튼 활성화 비활성화를 위한 value값
    int updateValue = 0;

    // dropdown 초기값 설정
    String dropDownValue = _userProfile.mainTitle.description;
    // title update
    String mainTitle = _userProfile.mainTitle.title;

    showModalBottomSheet(
      isScrollControlled: true, // 키보드가 올라올 때 바텀시트가 따라 올라감
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus(); //
                },
                child: Container(
                  height: bottomSheetHeight,
                  width: double.infinity,
                  margin: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "프로필 편집",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  updateValue = 0;
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  CupertinoIcons.xmark,
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () async {
                              pickedFile = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 30,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  updateValue = 1;
                                  // 서버에 보낼 이미지 경로 XFile? image;
                                  logger.d("image path : pickedFile!.path");
                                  sendData = pickedFile!.path;
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40, // 80 / 2
                                  backgroundImage: (pickedFile != null && pickedFile!.path.isNotEmpty)
                                    ? FileImage(File(pickedFile!.path))
                                    : (_userProfile.profilePic != null)
                                      ? NetworkImage(userPic) as ImageProvider
                                      : AssetImage(userPic),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Color(0xFF767676),
                                      size: 24,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 44,
                            width: double.infinity,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              controller:
                                  nicknameController, // TextEditingController를 연결
                              onChanged: (text) {
                                setState(() {
                                  nickname = text;
                                  updateValue = 1;
                                });
                              },
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: "닉네임",
                                hintText: '7글자까지 입력 가능해요',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF767676),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF767676),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF767676),
                                  )),
                                border: OutlineInputBorder(
                                  borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF767676),
                                  )
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<UserTitle>(
                                value: _userProfile.titles.firstWhere((title) => title.title == mainTitle), // 현재 선택된 항목
                                items: _userProfile.titles.map<DropdownMenuItem<UserTitle>>((UserTitle title) {
                                  return DropdownMenuItem<UserTitle>(
                                    value: title, // UserTitle 객체를 value로 사용
                                    child: Text(title.description), // description을 보여줌
                                  );
                                }).toList(),
                                onChanged: (UserTitle? selectedTitle) {
                                  if (selectedTitle != null) {
                                    setState(() {
                                      dropDownValue = selectedTitle!
                                          .description; // dropDownValue에 description 저장
                                      mainTitle = selectedTitle
                                          .title; // mainTitle에 title 저장
                                      updateValue = 1;
                                      logger.d("userTitle : ${mainTitle}");
                                      logger.d(
                                          "userTitleDescription : ${dropDownValue}");
                                    });
                                  }
                                },
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF767676),
                                ),
                              ),
                            )
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            height: 44,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0, // 그림자 제거
                                splashFactory: (updateValue == 0)
                                  ? NoSplash.splashFactory
                                  : InkSplash.splashFactory,
                                // 수정이 있을 경우 버튼 활성화
                                backgroundColor: (updateValue == 1)
                                  ? Color(0xffF15A2B)
                                  : Color(0xFFF4F4F4),
                                minimumSize: Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12))
                                )
                              ),
                              onPressed: () async {
                                // 프로필 수정
                                if (updateValue == 0) return;
                                userProfileUpdate = await viewModel.userProfileUpdateAPI(sendData, nickname, mainTitle);
                                logger.d("profile update : ${userProfileUpdate}");
                                // 프로필 수정에 성공할 경우 바텀시트 내리고 화면 새로고침
                                if (userProfileUpdate) {
                                  setState(() {
                                    updateValue = 0; // 상태 업데이트
                                    nicknameController.clear();
                                  });
                                  // setState가 완료된 후에 Navigator 호출
                                  Future.delayed(Duration.zero, () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyAppPage(initialIndex: 3)),
                                          (route) => false,
                                    );
                                  });
                                }
                              },
                              child: Text(
                                '저장',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: (updateValue == 1)
                                    ? Colors.white
                                    : Color(0xFF767676)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
