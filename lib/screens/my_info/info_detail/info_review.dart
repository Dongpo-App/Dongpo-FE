import 'package:flutter/material.dart';
import 'package:dongpo_test/models/user_review.dart';
import 'package:intl/intl.dart';
import '../../main/main_03/main_03.dart';
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
  void deleteUserReview(int reviewId) async {
    bool isReviewDeleted = await viewModel.userReviewDeleteAPI(context, reviewId);
    if (isReviewDeleted && mounted) {
      setState(() {
        getUserReview();
      });
    }
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
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "내가 쓴 리뷰",
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
          )
        ),
      ),
      body: _userReview.isEmpty
          ? const Center(
              child: Text(
                "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 24),
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
                      top: 24, right: 24, left: 24, bottom: 32
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
                                  // 버튼이 눌리면 해당 점포 상세 페이지로 이동
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return StoreInfo(idx: review.storeId);
                                  }));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      review.storeName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 24,
                                      color: Colors.black,
                                    )
                                  ]
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: review.reviewStar.toDouble(),
                                    itemCount: 5,
                                    itemSize: 16.0,
                                    unratedColor: const Color(0xFF767676),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Color(0xFFF15A2B),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    reviewDate,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF767676),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Text(
                                review.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              review.reviewPics.isEmpty // 리뷰 사진이 있으면 이미지 띄움
                              ? const SizedBox(height: 24,)
                              : reviewImageList(review.reviewPics),
                              Row(
                                children: [
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      // 리뷰 삭제
                                      deleteUserReview(review.id);
                                    },
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      alignment: Alignment.centerRight,
                                      child: const Text(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
