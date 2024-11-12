import 'dart:io';
import 'package:dongpo_test/models/response/api_response.dart';
import 'package:dongpo_test/models/user_profile.dart';
import 'package:dongpo_test/screens/my_info/info_detail/add_store.dart';
import 'package:dongpo_test/screens/my_info/my_page_view_model.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:dongpo_test/service/login_service.dart';
import 'package:dongpo_test/widgets/dialog_method_mixin.dart';
import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/login/apple_kakao_login.dart';
import 'package:dongpo_test/screens/login/login.dart';
import 'package:dongpo_test/screens/login/login_view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dongpo_test/widgets/bottom_navigation_bar.dart';
import 'package:dongpo_test/models/title.dart';
import 'info_detail/bookmark.dart';
import 'info_detail/info_review.dart';
import 'info_detail/info_title.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with DialogMethodMixin {
  LoginApiService loginService = LoginApiService.instance;
  late TextEditingController nicknameController;

  // 로그아웃 관련
  final loginViewModel = LoginViewModel(AppleKakaoLogin());
  String isLogouted = "";

  // 사용자 정보 관련
  MyPageViewModel viewModel = MyPageViewModel();
  late UserProfile _userProfile = UserProfile(
      nickname: "",
      profilePic: "",
      mainTitle: UserTitle(title: "", description: ""),
      titles: [],
      registerCount: 0,
      titleCount: 0,
      presentCount: 0);

  BuildContext? ancestorContext; // 조상 컨텍스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController();
    getUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ancestorContext = context; // 조상 컨텍스트 저장
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  Future<void> getUserProfile() async {
    final userProfileGet = await viewModel.userProfileGetAPI(context);
    if (mounted) {
      setState(() {
        _userProfile = userProfileGet;
        nicknameController.text = _userProfile.nickname;
      });
    }
  }

  // 프로필 사진 수정 관련
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double bodyHeight = (MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).viewInsets.bottom) *
        0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
        centerTitle: true,
        title: const Text(
          "마이 페이지",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: bodyHeight, // 전체 화면 높이 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                color: const Color(0x00ffffff),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 프로필 사진
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: (_userProfile.profilePic != null &&
                              _userProfile.profilePic!.isNotEmpty)
                          ? NetworkImage(_userProfile.profilePic!)
                              as ImageProvider
                          : const AssetImage('assets/images/profile.jpg'),
                    ),
                    const SizedBox(width: 16), // 간격 조정
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                        children: [
                          // 칭호
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5E0D9),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: const Color(0xFFF5E0D9), // 테두리 색상
                              ),
                            ),
                            child: Text(
                              _userProfile.mainTitle.description,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF15A2B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8), // 간격 조정
                          // 닉네임
                          Text(
                            _userProfile.nickname,
                            style: const TextStyle(
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
              const SizedBox(height: 40), // 간격 조정
              Container(
                height: 44,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                // 프로필 편집 버튼
                child: OutlinedButton(
                  onPressed: () {
                    showEditProfileBottomSheet(context);
                  },
                  style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ))),
                  child: const Text(
                    '프로필 편집',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF767676),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24), // 간격 조정
              // 등록한 가게, 칭호, 선물함
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 등록한 가게
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const AddStorePage();
                        }));
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _userProfile.registerCount.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF767676),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              '등록한 가게',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF767676),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 칭호
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const InfoTitlePage();
                        }));
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _userProfile.titleCount.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF767676),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              '칭호',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF767676),
                              ),
                            ),
                          ],
                        ),
                      ),
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
              const SizedBox(
                height: 24,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F4F4),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: const Text(
                    '내가 쓴 리뷰',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    // 내가 쓴 리뷰 버튼이 클릭되었을 때의 액션
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const InfoReviewPage();
                    }));
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: const Text(
                    '북마크 한 가게',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    // 북마크한 가게 버튼이 클릭되었을 때의 액션
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const BookmarkPage();
                    }));
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
                  padding: const EdgeInsets.all(24),
                  color: const Color(0xFFF4F4F4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final dialogResult = await showChoiceDialog(context,
                              title: "로그아웃", message: "정말로 로그아웃하시겠습니까?");
                          logger.d("dialog result : $dialogResult");
                          if (dialogResult == true) {
                            // 사용자가 확인을 누른 경우
                            try {
                              ApiResponse response =
                                  await loginService.logout();
                              // await NaverMapSdk.instance.initialize(
                              //   clientId: naverApiKey, // 클라이언트 ID 설정
                              //   onAuthFailed: (e) =>
                              //       logger.e("네이버맵 인증오류 : $e onAuthFailed"),
                              // );
                              if (response.statusCode == 200) {
                                MapManager().reset();
                                Fluttertoast.showToast(
                                    msg: "로그아웃 되었습니다.",
                                    toastLength: Toast.LENGTH_SHORT);
                                if (mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                }
                              } else if (response.statusCode == 500) {
                                Fluttertoast.showToast(
                                  msg: response.message,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 1,
                                );
                              }
                            } catch (e) {
                              if (e is TokenExpiredException ||
                                  e is ServerLogoutException) {
                                Fluttertoast.showToast(
                                  msg: e.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                );
                                if (mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                }
                              }
                            }
                          }
                        },
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF767676),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final platform = await storage.read(key: "loginPlatform");
                          final bool? dialogResult;

                          switch (platform){
                            case "apple":
                              dialogResult = await showChoiceDialog(context,
                                title: "회원 탈퇴", message: "탈퇴한 애플 계정으로 재가입이 불가능 해요");
                            case "kakao":
                              dialogResult = await showChoiceDialog(context,
                                  title: "회원 탈퇴", message: "정말 탈퇴하시겠어요?");
                            default:
                              dialogResult = false;
                          }
                          if (dialogResult == true) {
                            // 사용자가 확인을 누른 경우
                            try {
                              ApiResponse response =
                                  await loginService.deleteAccount();
                              if (response.statusCode == 200) {
                                MapManager().reset();
                                Fluttertoast.showToast(msg: "회원 탈퇴가 완료되었습니다.");
                                if (mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                }
                              } else if (response.statusCode == 500) {
                                Fluttertoast.showToast(
                                  msg: response.message,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 1,
                                );
                              }
                            } catch (e) {
                              if (e is TokenExpiredException ||
                                  e is AccountDeletionFailureException) {
                                Fluttertoast.showToast(
                                  msg: e.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                );
                                if (mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                }
                              }
                            }
                          }
                        },
                        child: const Text(
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
    final bottomSheetHeight = screenHeight * 0.5;

    // TextEditingController를 사용하여 초기값 설정
    String nickname = nicknameController.text;

    // userProfileUpdate 초기값 설정
    String userPic = (_userProfile.profilePic != null)
        ? _userProfile.profilePic!
        : 'assets/images/profile.jpg';

    // 사용자 사진 선택
    XFile? pickedFile;
    dynamic sendData;

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
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    height: bottomSheetHeight,
                    width: double.infinity,
                    margin: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
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
                                const Text(
                                  "프로필 편집",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    updateValue = 0;
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.xmark,
                                    size: 24,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            GestureDetector(
                              onTap: () async {
                                pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 30,
                                );
                                if (pickedFile != null && mounted) {
                                  setState(() {
                                    updateValue = 1;
                                    // 서버에 보낼 이미지 경로 XFile? image;
                                    sendData = pickedFile!.path;
                                  });
                                }
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 40, // 80 / 2
                                    backgroundImage: (pickedFile != null &&
                                            pickedFile!.path.isNotEmpty)
                                        ? FileImage(File(pickedFile!.path))
                                        : (_userProfile.profilePic != null)
                                            ? NetworkImage(userPic)
                                                as ImageProvider
                                            : AssetImage(userPic),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Color(0xFF767676),
                                        size: 24,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 64,
                              width: double.infinity,
                              child: TextField(
                                maxLength: 7,
                                textAlignVertical: TextAlignVertical.center,
                                controller:
                                    nicknameController, // TextEditingController를 연결
                                onChanged: (text) {
                                  if (mounted) {
                                    setState(() {
                                      if (text.length <= 7 && text.isNotEmpty) {
                                        nickname = text;
                                        updateValue = 1;
                                      } else {
                                        updateValue = 0;
                                      }
                                    });
                                  }
                                },
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                decoration: const InputDecoration(
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
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                                width: double.infinity,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<UserTitle>(
                                    value: _userProfile.titles.firstWhere(
                                        (title) =>
                                            title.title ==
                                            mainTitle), // 현재 선택된 항목
                                    items: _userProfile.titles
                                        .map<DropdownMenuItem<UserTitle>>(
                                            (UserTitle title) {
                                      return DropdownMenuItem<UserTitle>(
                                        value: title, // UserTitle 객체를 value로 사용
                                        child: Text(title
                                            .description), // description을 보여줌
                                      );
                                    }).toList(),
                                    onChanged: (UserTitle? selectedTitle) {
                                      if (selectedTitle != null && mounted) {
                                        setState(() {
                                          dropDownValue = selectedTitle
                                              .description; // dropDownValue에 description 저장
                                          mainTitle = selectedTitle
                                              .title; // mainTitle에 title 저장
                                          updateValue = 1;
                                          logger.d("userTitle : $mainTitle");
                                          logger.d(
                                              "userTitleDescription : $dropDownValue");
                                        });
                                      }
                                    },
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF767676),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 24),
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
                                        ? const Color(0xffF15A2B)
                                        : const Color(0xFFF4F4F4),
                                    minimumSize:
                                        const Size(double.infinity, 44),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)))),
                                onPressed: () async {
                                  if (updateValue == 0) return;

                                  userProfileUpdate =
                                      await viewModel.userProfileUpdateAPI(
                                          context,
                                          sendData,
                                          nickname,
                                          mainTitle);
                                  logger
                                      .d("profile update : $userProfileUpdate");

                                  if (userProfileUpdate) {
                                    // 상태 업데이트를 제거하고 바로 네비게이션 수행
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyAppPage(initialIndex: 3)),
                                      (route) => false,
                                    );
                                  }
                                },
                                child: Text(
                                  '저장',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: (updateValue == 1)
                                          ? Colors.white
                                          : const Color(0xFF767676)),
                                ),
                              ),
                            ),
                          ],
                        ),
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
