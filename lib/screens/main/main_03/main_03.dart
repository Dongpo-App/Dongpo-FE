//가게정보 자세히
import 'dart:convert';

import 'package:dongpo_test/models/store_detail.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:dongpo_test/screens/main/main_03/04_bangmoon.dart';
import 'package:dongpo_test/screens/main/main_03/06_gagejungbo.dart';
import 'package:dongpo_test/screens/main/main_03/02_photo_List.dart';
import 'package:dongpo_test/screens/main/main_03/05_review.dart';
import 'package:dongpo_test/screens/main/main_03/01_title.dart';
import 'package:dongpo_test/screens/main/main_03/03_user_action.dart';
import 'package:dongpo_test/screens/main/main_03/07_dangol.dart';
import 'package:dongpo_test/screens/my_info/info_detail/bookmark_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StoreInfo(
        idx: 1, // class.idx로 수정
      ),
    );
  }
}

//가게정보 상세 페이지

class StoreInfo extends StatefulWidget {
  final int idx;
  const StoreInfo({super.key, required this.idx});
  @override
  State<StoreInfo> createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  BookmarkViewModel viewModel = BookmarkViewModel();
  void getBookmark() async {
    userBookmark = await viewModel.userBookmarkGetAPI(context);
  }

  @override
  void initState() {
    super.initState();
    getBookmark();
    // 페이지가 처음 생성될 때 비동기 메서드 호출
    _fetchStoreDetails();
  }

  // 비동기 메서드로 가게 정보를 가져옴
  Future<void> _fetchStoreDetails() async {
    try {
      final data = await _storeSangse(); // 비동기 호출

      setState(() {
        storeData = data; // 가져온 데이터를 myStoreList에 할당
      });
    } catch (e) {
      logger.e('가게 정보 불러오는데 뭔가 잘못됌 에러 사유: $e'); // 에러 처리
    }
  }

  //라디오 버튼 관련 변수
  int value = 0;
  static const storage = FlutterSecureStorage();
  // 점포 신고
  void storeReport(int storeId) async {
    final url = Uri.parse('$serverUrl/api/report/store/$storeId');

    final accessToken = await storage.read(key: 'accessToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
    } else {
      logger.e(
          'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : ${response.body}');
      throw Exception('HTTP ERROR !!! ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //앱바 뒤로가기, 신고하기
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
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
        actions: [
          IconButton(
            onPressed: () {
              //신고 기능 구현
              showModalBottomSheet(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              const Text(
                                "가게에 문제가 있나요?",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() => value = 0);
                                  Navigator.pop(context);
                                },
                                icon : const Icon(
                                CupertinoIcons.xmark,
                                size: 24,
                              ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            "항목에 알맞게 선택해주세요.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _radioBtn('없어진 가게에요', 1, setState),
                                const SizedBox(
                                  height: 16,
                                ),
                                _radioBtn('위치가 틀려요', 2, setState),
                                const SizedBox(
                                  height: 16,
                                ),
                                _radioBtn('부적절한 정보가 포함되어 있어요', 3, setState),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              logger.d("사용하고있는 값 : ${widget.idx}");
                              (value == 0) ? null : storeReport(value);
                              // 신고 api 추가
                            },
                            style: ElevatedButton.styleFrom(
                              splashFactory: (value == 0) // 아무것도 터치 안했으면
                                ? NoSplash.splashFactory //스플레시 효과 비활성화
                                : InkSplash.splashFactory, //스플레시 효과 활성화
                              minimumSize: const Size(double.infinity, 40),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(0))
                              ),
                              backgroundColor: value != 0
                                ? const Color(0xffF15A2B)
                                : const Color(0xFFF4F4F4),
                            ),
                            child: Text(
                              "가게 신고",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: (value > 0)
                                  ? Colors.white
                                  : const Color(0xFF767676),
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                  );
                });
              });
            },
            icon: const Icon(
              Icons.warning_rounded,
              color: Color(0xffF15A2B),
              size: 24,
            ),
          )
        ],
      ),
      body: storeData == null // storeData가 null인 경우 로딩 표시
        ? const Center(child: CircularProgressIndicator())
        : Container(
          margin: const EdgeInsets.all(24),
          child: ListView(
            children: [
              //제목, 영업가능성, 거리
              MainTitle(idx: widget.idx),
              //사진
              const SizedBox(
                height: 24,
              ),
              const MainPhoto(),
              const SizedBox(
                height: 32,
              ),
              //리뷰 갯수, 버튼
              UserAction(idx: widget.idx),
              const SizedBox(
                height: 30,
              ),
              //방문인증
              const BangMoon(),
              const SizedBox(
                height: 40,
              ),
              //리뷰 관련
              ShowReview(idx: widget.idx),
              const SizedBox(
                height: 80,
              ),
              //가게정보
              const GageJungbo(),
              const SizedBox(
                height: 80,
              ),
              //이 가게 단골 손님
              const DanGolGuest(),
            ],
          ),
        ),
    );
  }

  Widget _radioBtn(String text, int index, StateSetter setStater) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setStater(() {
            value = index;
            print('$index');
          });
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(double.infinity, 40),
          backgroundColor:
            (value == index) ? const Color(0xFFF15A2B) : const Color(0xFFF4F4F4),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: (value == index) ? Colors.white : const Color(0xFF767676)
          ),
        ),
      ),
    );
  }

  Future<StoreSangse> _storeSangse() async {
    final accessToken = await storage.read(key: 'accessToken');

    final url = Uri.parse('$serverUrl/api/store/${widget.idx}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(url, headers: headers);
    final Map<String, dynamic> data =
        json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      // 응답 데이터에서 'data' 필드 추출 후, StoreSangse 객체로 변환
      final Map<String, dynamic> jsonData = data['data'];

      // StoreSangse 객체 생성
      final StoreSangse storeData = StoreSangse.fromJson(jsonData);

      return storeData;
    } else {
      logger.e(
          '가게정보 상세 불러오는 중 (가게 id : ${widget.idx}) HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답본문 : $data');
      throw Exception('Failed to load 가게상세정보');
    }
  }
}


//기본색깔 0xffF15A2B
//MediaQuery.of(context).size.height
