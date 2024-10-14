import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/models/user_review.dart';
import 'info_review_view_model.dart';

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
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userReview[index].storeName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(// 테스트용
                                width: 30,
                              ),
                              Text(
                                _userReview[index].text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]
                          )
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
