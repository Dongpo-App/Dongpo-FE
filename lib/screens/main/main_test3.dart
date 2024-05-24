import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

class ShowReview extends StatefulWidget {
  const ShowReview({Key? key}) : super(key: key);

  @override
  State<ShowReview> createState() => _ShowReviewState();
}

class _ShowReviewState extends State<ShowReview> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  Widget _addPhotoButton() {
    return IconButton(
      onPressed: () {
        _pickImg();
      },
      icon: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange, width: 1),
        ),
        child: Icon(
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

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('리뷰 작성을 종료하시겠습니까?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('저장된 정보가 전부 사라집니다!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('네'),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "리뷰 A개",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "방문 후기를 알려주세요",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  _showConfirmationDialog(context);
                                },
                                icon: Icon(CupertinoIcons.xmark,
                                    color: Colors.black, size: 30),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //별점 RatingBar
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
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Color(0xffF15A2B),
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //사진 첨부 텍스트
                          Row(
                            children: [
                              Text(
                                "사진 첨부",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(" 최대 3개까지 선택 가능해요"),
                            ],
                          ),
                          SizedBox(height: 10),
                          // 사진 첨부 버튼과 이미지 미리보기
                          Row(
                            children: List.generate(
                              3,
                              (index) => Container(
                                margin: EdgeInsets.all(5),
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
                                    ? _addPhotoButton()
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //텍스트 필드 (200글자 이내로 작성해주세요!)
                          SizedBox(
                            height: 200,
                            child: TextField(
                              controller: _reviewController,
                              maxLength: 200,
                              maxLines: 4,
                              decoration: InputDecoration(
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
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text("리뷰 등록"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Center(child: Text("리뷰 쓰러가기")),
          ),
          SizedBox(height: 15),
          SizedBox(height: 40),
          _showReview(context, 4),
          _showReview(context, 3.2),
          _showReview(context, 5.0),
        ],
      ),
    );
  }

  // 개별 리뷰를 표시하는 함수
  Widget _showReview(BuildContext context, double rating) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이 가게 단골 손님',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/rakoon.png'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('연수민'),
                        SizedBox(width: 20),
                        Text("난 한가게만 패"),
                      ],
                    ),
                    RatingWidget(rating: rating), // 별점 위젯 추가
                  ],
                ),
              ],
            ),
            Text("리뷰 내용입니다..."),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Image(image: AssetImage('assets/images/rakoon.png')),
                  Image(image: AssetImage('assets/images/rakoon.png')),
                  Image(image: AssetImage('assets/images/rakoon.png')),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("2024.04.02"),
                Spacer(),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 200,
                          child: Center(child: Text('신고하기')),
                        );
                      },
                    );
                  },
                  child: Text("신고",
                      style: TextStyle(fontSize: 20, color: Colors.orange)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
          ],
        ),
      ),
    );
  }

  //이미지 가져오기
  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage(
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );
    if (images != null) {
      setState(() {
        _pickedImgs = images.take(3).toList(); // 최대 3장까지 추가 가능
      });
    }
  }
}

// 별점을 표시하는 위젯
class RatingWidget extends StatelessWidget {
  final double rating; // 평점 값
  const RatingWidget({Key? key, required this.rating}) : super(key: key);

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
        stars.add(Icon(Icons.star, color: Colors.orange)); //start full
      } else if (i - rating <= 0.5) {
        stars.add(Icon(Icons.star_half, color: Colors.orange)); //star half
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.orange)); //start blank
      }
    }
    return stars;
  }
}
