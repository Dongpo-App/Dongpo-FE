import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

int value = 0;

class ShowReview extends StatefulWidget {
  final int idx;
  const ShowReview({super.key, required this.idx});

  @override
  State<ShowReview> createState() => _ShowReviewState();
}

//사진 관련
class _ShowReviewState extends State<ShowReview> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

//여기서 부터 화면
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "리뷰 A개",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            children: [
                              //상단 1
                              Row(
                                children: [
                                  const Text(
                                    "방문 후기를 알려주세요",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      _showConfirmationDialog(context);
                                    },
                                    icon: const Icon(CupertinoIcons.xmark,
                                        color: Colors.black, size: 30),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //별점 RatingBar //상단 2
                              Row(
                                children: [
                                  RatingBar.builder(
                                    minRating: 0.5,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    glowRadius: 1,
                                    glow: false,
                                    itemPadding: EdgeInsets.zero,
                                    itemSize: 60,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color(0xffF15A2B),
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating;
                                        print(rating);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //사진 첨부 텍스트 //상단 3
                              const Row(
                                children: [
                                  Text(
                                    "사진 첨부",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(" 최대 3개까지 선택 가능해요"),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // 사진 첨부 버튼과 이미지 미리보기 //상단 4
                              Row(
                                children: List.generate(
                                  3,
                                  (index) => Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: index < _pickedImgs.length
                                              ? Colors.transparent
                                              : Colors.white70,
                                          width: 1),
                                      image: index < _pickedImgs.length
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                File(_pickedImgs[index].path),
                                              ),
                                            )
                                          : null,
                                    ),
                                    child: index == _pickedImgs.length
                                        ? _addPhotoButton(setState)
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //텍스트 필드 (200글자 이내로 작성해주세요!) //상단 5
                              SizedBox(
                                height: 200,
                                child: TextField(
                                  controller: _reviewController,
                                  maxLength: 200,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '200 글자 이내로 적어주세요!',
                                  ),
                                ),
                              ),

                              //바닥에 리뷰 등록 버튼 (form전송)
                              ElevatedButton(
                                onPressed: () {
                                  // 리뷰 등록 버튼 로직
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  backgroundColor: const Color(0xffF15A2B),
                                ),
                                child: const Text(
                                  "리뷰 등록",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: const Color(0xffF15A2B),
              ),
              child: const Text(
                '리뷰 등록',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 40),
          const SizedBox(height: 40),
          _showReview(context, 4),
          _showReview(context, 3.2),
          _showReview(context, 5.0),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShowAllReviews(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: const Color(0xffF15A2B),
              ),
              child: const Text(
                '리뷰 더보기',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addPhotoButton(setState) {
    return IconButton(
      onPressed: () {
        _pickImg(setState);
      },
      icon: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange, width: 1),
        ),
        child: const Icon(
          CupertinoIcons.camera,
          color: Colors.orange,
          size: 30,
        ),
      ),
    );
  }

  void _resetReview() {
    setState(() {
      _pickedImgs = [];
      _rating = 0;
      _reviewController.clear();
    });
  }

  //리뷰 컨펌
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('리뷰 작성을 종료하시겠습니까?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('저장된 정보가 전부 사라집니다!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('네'),
              onPressed: () {
                _resetReview();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //이미지 가져오기
  Future<void> _pickImg(setState) async {
    final List<XFile> images = await _picker.pickMultiImage(
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );
    setState(() {
      _pickedImgs = images.take(3).toList(); // 최대 3장까지 추가 가능
    });
  }
}

// 별점을 표시하는 위젯
class RatingWidget extends StatelessWidget {
  final double rating; // 평점 값
  const RatingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ..._buildStarIcons(), // 별 아이콘을 생성하여 추가
      ],
    );
  }

  // 별 아이콘 리스트를 생성하는 함수
  List<Widget> _buildStarIcons() {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(const Icon(Icons.star, color: Colors.orange)); //start full
      } else if (i - rating <= 0.5) {
        stars
            .add(const Icon(Icons.star_half, color: Colors.orange)); //star half
      } else {
        stars.add(
            const Icon(Icons.star_border, color: Colors.orange)); //start blank
      }
    }
    return stars;
  }
}

// 개별 리뷰를 표시하는 함수
Widget _showReview(BuildContext context, double rating) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/rakoon.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('연수민'),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red[100],
                        ),
                        child: Text(
                          "난 한 가게만 패",
                          style: TextStyle(
                              fontSize: 10, color: Colors.redAccent[400]),
                        ),
                      ),
                    ],
                  ),
                  RatingWidget(rating: rating), // 별점 위젯 추가
                ],
              ),
            ],
          ),
          const Text("리뷰 내용입니다..."),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                Image(image: AssetImage('assets/images/rakoon.png')),
                Image(image: AssetImage('assets/images/rakoon.png')),
                Image(image: AssetImage('assets/images/rakoon.png')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text("2024.04.02"),
              const Spacer(),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "리뷰 신고하기",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          setState(() => value = 0);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(CupertinoIcons.xmark))
                                  ],
                                ),
                                //버튼 모음
                                Container(
                                  height: 350,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _radioBtn('홍보성 리뷰에요', 1, setState),
                                      _radioBtn('도배 글이에요', 2, setState),
                                      _radioBtn('부적절한 내용이에요(욕설, 선정적 내용 등)', 3,
                                          setState),
                                      _radioBtn('가게에 무관한 리뷰에요', 4, setState),
                                      _radioBtn('기타', 5, setState),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            (value == 0)
                                                ? null
                                                : print('버튼 활성화');
                                            //dio.post()구현
                                          },
                                          style: ElevatedButton.styleFrom(
                                            splashFactory: (value ==
                                                    0) // 아무것도 터치 안했으면
                                                ? NoSplash
                                                    .splashFactory //스플레시 효과 비활성화
                                                : InkSplash
                                                    .splashFactory, //스플레시 효과 활성화
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            minimumSize:
                                                const Size(double.infinity, 40),
                                            backgroundColor: value != 0
                                                ? const Color(0xffF15A2B)
                                                : Colors.grey[300],
                                          ),
                                          child: Text(
                                            "가게 신고",
                                            style: TextStyle(
                                                color: (value > 0)
                                                    ? Colors.white
                                                    : Colors.grey[600]),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
                child: const Text("신고",
                    style: TextStyle(fontSize: 20, color: Colors.orange)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    ),
  );
}

Widget _radioBtn(String text, int index, StateSetter setStater) {
  return ElevatedButton(
    onPressed: () {
      setStater(() {
        value = index;
        print('$index');
      });
    },
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      minimumSize: const Size(double.infinity, 40),
      backgroundColor:
          (value == index) ? const Color(0xffF15A2B) : Colors.grey[300],
    ),
    child: Text(
      text,
      style:
          TextStyle(color: (value == index) ? Colors.white : Colors.grey[600]),
    ),
  );
}

class ShowAllReviews extends StatelessWidget {
  const ShowAllReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 전체'),
      ),
      body: ListView(
        children: [
          _showReview(context, 4),
          _showReview(context, 4),
          _showReview(context, 4),
          _showReview(context, 4),
          _showReview(context, 4),
          _showReview(context, 4)
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("리뷰 등록"),
    content: const Text("리뷰 등록이 완료되었습니다."),
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
