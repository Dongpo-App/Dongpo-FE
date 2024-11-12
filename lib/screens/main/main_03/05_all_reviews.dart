import 'dart:convert';
import 'package:dongpo_test/models/store/store_detail.dart';
import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dongpo_test/screens/login/login_view_model.dart';
import 'package:dongpo_test/service/store_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dongpo_test/main.dart';
import 'package:intl/intl.dart';

class ShowAllReviews extends StatefulWidget {
  final int idx;
  const ShowAllReviews({super.key, required this.idx});

  @override
  State<ShowAllReviews> createState() => _ShowAllReviewsState();
}

int value = 0;

class _ShowAllReviewsState extends State<ShowAllReviews> {
  StoreApiService storeService = StoreApiService.instance;
  MapManager manager = MapManager();
  List<Review> reviewList = [];

  @override
  void initState() {
    getAllReviews(widget.idx);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            "전체 리뷰",
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
              )),
        ),
        body: ListView.builder(
          shrinkWrap: true, // 높이를 자동으로 조정

          itemCount: reviewList.length,
          itemBuilder: (context, index) {
            logger.d('리뷰 리스트에 들어있는 값 체크 : $reviewList');

            return _showReview(context, index); // 각 리뷰 위젯 생성
          },
        ));
  }

// 개별 리뷰를 표시하는 함수
  Widget _showReview(BuildContext context, int index) {
    String reviewDate =
        DateFormat('yyyy-MM-dd').format(reviewList[index].registerDate);
    bool reportTextChecked = false;

    return Container(
      margin: const EdgeInsets.only(top: 24, right: 24, left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: (reviewList[index].memberProfilePic != null &&
                        reviewList[index].memberProfilePic!.isNotEmpty)
                    ? NetworkImage('${reviewList[index].memberProfilePic}')
                        as ImageProvider
                    : const AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${reviewList[index].memberNickname}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF5E0D9),
                          border: Border.all(
                            color: const Color(0xFFF5E0D9), // 테두리 색상
                          ),
                        ),
                        child: Text(
                          "${reviewList[index].memberMainTitle}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF15A2B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  RatingBarIndicator(
                    rating: reviewList[index].reviewStar!,
                    itemCount: 5,
                    itemSize: 16.0,
                    unratedColor: const Color(0xFF767676),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color(0xFFF15A2B),
                    ),
                  ),
                  // RatingWidget(
                  //     rating: reviewList[index].reviewStar ?? 0), // 별점 위젯 추가
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            '${reviewList[index].reviewText}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          reviewList[index].reviewPics?.isEmpty ?? true
              ? const SizedBox(
                  height: 0,
                )
              : SizedBox(
                  height: 64,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: reviewList[index]
                        .reviewPics!
                        .map((url) => GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.black,
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width, // 화면의 너비
                                        height: MediaQuery.of(context)
                                            .size
                                            .height, // 화면의 높이
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.contain, // 이미지 비율 유지
                                            image: NetworkImage(url),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 64, // 이미지 너비
                                height: 64,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(url),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  )),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                reviewDate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF767676),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  TextEditingController textController =
                      TextEditingController();

                  String etcText2 = ''; // 리뷰 전체 신고

                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true, // 모달 시트의 크기를 조절 가능하게 설정
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 24,
                            bottom: MediaQuery.of(context)
                                .viewInsets
                                .bottom, // 키보드가 올라오면 그만큼 패딩 추가
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "리뷰 신고하기",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            setState(() => value = 0);
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            CupertinoIcons.xmark,
                                            size: 24,
                                            color: Color(0xFF767676),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Column(
                                      children: [
                                        _radioBtn('홍보성 리뷰에요', 1, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('도배 글이에요', 2, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('부적절한 내용이에요(욕설, 선정적 내용 등)', 3,
                                            setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('가게에 무관한 리뷰에요', 4, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('기타', 5, setState),
                                        if (value == 5)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: TextField(
                                              controller: textController,
                                              onChanged: (text) {
                                                if (text.isNotEmpty) {
                                                  reportTextChecked = true;
                                                } else {
                                                  reportTextChecked = false;
                                                }
                                              },
                                              maxLength: 100,
                                              decoration: const InputDecoration(
                                                hintText: '기타 사항을 입력해주세요',
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF767676),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12)),
                                                        borderSide: BorderSide(
                                                          width: 1,
                                                          color:
                                                              Color(0xFF767676),
                                                        )),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Color(0xFF767676),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 32),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (value == 5 &&
                                                !reportTextChecked) {
                                              return;
                                            }
                                            if (value != 0) {
                                              etcText2 = (value == 5)
                                                  ? textController.text
                                                  : "";
                                              reviewStoreReport2(
                                                  index, etcText2);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            splashFactory: value == 0
                                                ? NoSplash.splashFactory
                                                : InkSplash.splashFactory,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            minimumSize:
                                                const Size(double.infinity, 44),
                                            backgroundColor:
                                                ((value > 0 && value < 5) ||
                                                        (value == 5 &&
                                                            reportTextChecked))
                                                    ? const Color(0xffF15A2B)
                                                    : const Color(0xFFF4F4F4),
                                          ),
                                          child: Text(
                                            "리뷰 신고",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: ((value > 0 &&
                                                          value < 5) ||
                                                      (value == 5 &&
                                                          reportTextChecked))
                                                  ? Colors.white
                                                  : const Color(0xFF767676),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
                child: const Text(
                  "신고",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF767676),
                    decoration: TextDecoration.underline, // 밑줄 추가
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(
            color: Color(0xFFD0D0D0),
          ),
        ],
      ),
    );
  }

  //리뷰 전체 조회
  // 비동기 메서드로 가게 정보를 가져옴
  Future<void> getAllReviews(int id) async {
    final url = Uri.parse('$serverUrl/api/store/review/$id');

    final accessToken = await storage.read(key: 'accessToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      // JSON 데이터 디코딩 및 UTF-8 디코딩
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));

      // 서버에서 받은 데이터 중 'data' 키의 값을 리스트로 가져옴
      final List<dynamic> jsonData = data['data'];

      // JSON 배열을 UserBookmark 리스트로 변환
      setState(() {
        reviewList =
            jsonData.map((jsonItem) => Review.fromJson(jsonItem)).toList();
      });
    } else {
      logger.e(
          'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : ${response.body}');
      throw Exception('HTTP ERROR !!! ${response.body}');
    }
  }

  // 리뷰 점포 신고
  void reviewStoreReport2(int idx, String etcText) async {
    String sendData = setReportData(value);
    logger.d("sendData : $sendData");
    final url = Uri.parse('$serverUrl/api/report/review/${reviewList[idx].id}');

    final accessToken = await storage.read(key: 'accessToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final includeTextData = {
      "text": etcText, // reason이 ETC일 경우 포함
      "reason": sendData,
    };

    final exceptTextData = {
      "reson": sendData,
    };
    logger.d("_send : sendData");
    Map<String, String> data;

    if (value == 5) {
      data = includeTextData;
    } else {
      data = exceptTextData;
    }

    logger.d('send Body check value : $value data : $data');

    final body = jsonEncode(data);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      final responsebody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        logger.d('신고 완료!! 신고 내용 : $sendData & ETC : $etcText');
        logger.d('신고한 리뷰 ID = :${reviewList[idx].id}');
        showSuccessDialog();
      } else {
        logger.e(
            'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : $responsebody');
      }
    } catch (e) {
      // TODO
      logger.d("HTTP ERROR in storeReposrt method!! Error 내용 : $e");
    }
  }

  String setReportData(int idx) {
    switch (idx) {
      case 1:
        return "PROMOTIONAL_REVIEW";
      case 2:
        return "SPAM";
      case 3:
        return " INAPPOSITE_INFO";
      case 4:
        return "IRRELEVANT_CONTENT";
      case 5:
        return "ETC";
      default:
        "";
    }

    return "";
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
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "신고 성공!",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "성공적으로 신고가 접수되었어요!",
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

  Widget _radioBtn(String text, int index, StateSetter setStater) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setStater(() {
            value = index;
            logger.d('선택한 index : $index');
          });
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          elevation: 0,
          minimumSize: const Size(double.infinity, 44),
          backgroundColor: (value == index)
              ? const Color(0xffF15A2B)
              : const Color(0xFFF4F4F4),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: (value == index) ? Colors.white : const Color(0xFF767676)),
        ),
      ),
    );
  }
}
