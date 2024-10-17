import 'package:dongpo_test/models/community_rack.dart';
import 'package:dongpo_test/screens/community/community_view_model.dart';
import 'package:flutter/material.dart';
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
    _storeTop10GetAPI = await viewModel.storeTop10GetAPI(context);
    _visitTop10GetAPI = await viewModel.visitTop10GetAPI(context);
    _reviewTop10GetAPI = await viewModel.reviewTop10GetAPI(context);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 Text
              Container(
                margin: const EdgeInsets.only(top: 24.0, left: 24.0, bottom: 48),
                child: const Text(
                  "별별 사람들",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                )
              ),
          
              // 조건 Top 10 카드 슬라이드
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 24.0), // 왼쪽 24 margin
                    _buildCard(
                      top10Title: '방문 인증 횟수 top 10',
                      member: _visitTop10GetAPI.first.nickname,
                      memberTitle: _visitTop10GetAPI.first.title,
                      memberProfile: _visitTop10GetAPI.first.pic,
                      top10List: _visitTop10GetAPI,
                    ),
                    const SizedBox(width: 24.0), // 카드 사이의 거리
                    _buildCard(
                      top10Title: '가게 등록 횟수 top 10',
                      member: _storeTop10GetAPI.first.nickname,
                      memberTitle: _storeTop10GetAPI.first.title,
                      memberProfile: _storeTop10GetAPI.first.pic,
                      top10List : _storeTop10GetAPI,
                    ),
                    const SizedBox(width: 24.0),
                    _buildCard(
                      top10Title: '가게 리뷰 횟수 top 10',
                      member: _reviewTop10GetAPI.first.nickname,
                      memberTitle: _reviewTop10GetAPI.first.title,
                      memberProfile: _reviewTop10GetAPI.first.pic,
                      top10List : _reviewTop10GetAPI,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24.0),
              Container(
                width: double.infinity,
                height: 64.0,
                margin: const EdgeInsets.all(24),
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
        ),
      ),
    );
  }

  // 조건 Top 10 카드 슬라이드 3개
  Widget _buildCard({
    required String top10Title,
    required String member,
    required String memberTitle,
    required String? memberProfile,
    required List<CommunityRank> top10List,
  })
  {
    final top10TitleData = Top10TitleData(
      top10Title: top10Title,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return CommunityTop10Page(
              top10TitleData: top10TitleData,
              top10List: top10List,
            );
          }
        ));
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
                backgroundImage: (memberProfile != null && memberProfile.isNotEmpty)
                    ? NetworkImage(memberProfile) as ImageProvider
                    : const AssetImage('assets/images/profile.jpg'),
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
      )
    );
  }
}

// 카드 데이터 DTO
class Top10TitleData {
  final String top10Title;
  Top10TitleData({
    required this.top10Title,
  });
}
