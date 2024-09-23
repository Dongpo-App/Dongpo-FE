import 'package:dongpo_test/models/community_rack.dart';
import 'package:dongpo_test/screens/community/community_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/models/title.dart';
import 'community_top10.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  // 커뮤니티 Top 10
  CommunityViewModel viewModel = CommunityViewModel();
  late List<CommunityRank> _storeTop10GetAPI = [
    CommunityRank(
      nickname: "",
      title: "",
      pic: "",
      count: 0,
    ),
  ];
  late List<CommunityRank> _visitTop10GetAPI = [
    CommunityRank(
      nickname: "",
      title: "",
      pic: "",
      count: 0,
    ),
  ];
  late List<CommunityRank> _reviewTop10GetAPI = [
    CommunityRank(
      nickname: "",
      title: "",
      pic: "",
      count: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    getTop10();
  }

  void getTop10() async {
    _storeTop10GetAPI = await viewModel.storeTop10GetAPI();
    _visitTop10GetAPI = await viewModel.visitTop10GetAPI();
    _reviewTop10GetAPI = await viewModel.reviewTop10GetAPI();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 Text
          Container(
              margin: const EdgeInsets.only(top: 24.0, left: 24.0, bottom: 48),
              child: const Text(
                "별별 사람들",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              )),

          // 조건 Top 10 카드 슬라이드
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 24.0), // 왼쪽 24 margin
                _buildCard(
                  top10Title: '방문 인증 횟수 top 10',
                  member: '도도한 고양이',
                  memberTitle: '난 한 가게만 패',
                  memberProfile: 'assets/images/profile_img1.jpg',
                ),
                const SizedBox(width: 24.0), // 카드 사이의 거리
                _buildCard(
                  top10Title: '가게 등록 횟수 top 10',
                  member: '친절한 강아지',
                  memberTitle: '포장마차 러버',
                  memberProfile: 'assets/images/profile_img2.jpg',
                ),
                const SizedBox(width: 24.0),
                _buildCard(
                  top10Title: '가게 리뷰 횟수 top 10',
                  member: '행복한 참새',
                  memberTitle: '애미야 국이 짜다',
                  memberProfile: 'assets/images/profile_img3.jpg',
                ),
                const SizedBox(width: 24.0),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 64.0,
            margin: const EdgeInsets.only(top: 64, left: 24.0, right: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              image: const DecorationImage(
                image: AssetImage('assets/images/banner.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 조건 Top 10 카드 슬라이드 3개
  Widget _buildCard(
      {required String top10Title,
      required String member,
      required String memberTitle,
      required String memberProfile}) {
    final top10TitleData = Top10TitleData(
      top10Title: top10Title,
    );

    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return CommunityTop10Page(top10TitleData: top10TitleData);
          }));
        },
        child: Container(
          //
          width: 260.0,
          height: 213.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Text(
                  top10Title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 29),
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(memberProfile),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 19),
                child: Text(
                  memberTitle,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  member,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// 카드 데이터 DTO
class Top10TitleData {
  final String top10Title;
  Top10TitleData({
    required this.top10Title,
  });
}
