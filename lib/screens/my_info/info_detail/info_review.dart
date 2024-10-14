import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/models/user_review.dart';
import 'package:intl/intl.dart';
import 'info_review_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InfoReviewPage extends StatefulWidget {
  const InfoReviewPage({super.key});

  @override
  State<InfoReviewPage> createState() => InfoReviewPageState();
}

class InfoReviewPageState extends State<InfoReviewPage> {
  InfoReviewViewModel viewModel = InfoReviewViewModel();

  late List<UserReview> _userReview = [];

  @override
  void initState(){
    super.initState();
    getUserReview();
  }
  void getUserReview() async {
    _userReview = await viewModel.userReviewGetAPI(context);
    setState(() {});
  }

  // 리뷰 사진 함수
  Widget reviewImageList(List<String> imageUrls) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      height: 128, // 이미지 높이
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: imageUrls.map((url) => GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.black,
                  child: Container(
                    width: MediaQuery.of(context).size.width, // 화면의 너비
                    height: MediaQuery.of(context).size.height, // 화면의 높이
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
            width: 128, // 이미지 너비
            height: 128,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(url),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "내가 쓴 리뷰",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
      body: _userReview.isEmpty
          ? const Center(
              child: Text(
                "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ListView.builder(
                itemCount: _userReview.length,
                itemBuilder: (context, index) {
                  var review = _userReview[index];
                  String reviewDate = DateFormat('yyyy-MM-dd').format(_userReview[index].registerDate);
                  return Card(
                    elevation: 0,
                    color: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 24, right: 24, left: 24, bottom: 48
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // 가게 이름이 클릭되었을 때 액션
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        review.storeName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 24,
                                        color: Colors.black,
                                      )
                                    ]
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: review.reviewStar.toDouble(), // 확인할 별점 값
                                      itemCount: 5,
                                      itemSize: 16.0,
                                      unratedColor: Color(0xFF767676), // 채워지지 않은 별의 색상
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Color(0xFFF15A2B),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      reviewDate,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF767676),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  _userReview[index].text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                review.reviewPics.isEmpty // 리뷰 사진이 있으면 이미지 띄움
                                ? SizedBox(height: 24,)
                                : reviewImageList(review.reviewPics),
                                GestureDetector(
                                  onTap: () async {
                                    // 리뷰 삭제
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '삭제',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xFF767676),
                                        decoration: TextDecoration.underline, // 밑줄 추가
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
