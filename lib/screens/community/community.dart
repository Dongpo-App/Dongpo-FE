import 'package:dongpo_test/models/community_rack.dart';
import 'package:dongpo_test/models/recommend_store.dart';
import 'package:dongpo_test/screens/community/community_view_model.dart';
import 'package:flutter/material.dart';
import 'community_top10.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  // 사용자 점포 추천
  String userAge = "20";
  String userGender = "남";
  // 점포 추천 분류
  String recommendStoreCategory = "나이";
  // 점포 추천 데이터
  List<RecommendStore> _recommendStore = [];

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
    getRecommendStore();
  }

  void getTop10() async {
    _storeTop10GetAPI = await viewModel.storeTop10GetAPI(context);
    _visitTop10GetAPI = await viewModel.visitTop10GetAPI(context);
    _reviewTop10GetAPI = await viewModel.reviewTop10GetAPI(context);
    setState(() {});
  }

  void getRecommendStore() {
    if (recommendStoreCategory == "나이") {
      _recommendStore = [
        RecommendStore.fromMap({
          "id": 3,
          "name": "써브웨이",
          "address": "서울시 구로구 고척동",
          "businessPotential": "영업 가능성 높아요",
        }),
        RecommendStore.fromMap({
          "id": 2,
          "name": "노랑통닭",
          "address": "서울시 구로구 고척동",
          "businessPotential": "영업 가능성 낮아요",
        }),
        RecommendStore.fromMap({
          "id": 9,
          "name": "전주맛집",
          "address": "서울시 구로구 고척동",
          "businessPotential": "영업 가능성 높아요",
        }),
      ];
    } else {
      _recommendStore = [
        RecommendStore.fromMap({
          "id": 3,
          "name": "청년다방",
          "address": "서울시 구로구 고척동",
          "businessPotential": "영업 가능성 낮아요",
        }),
        RecommendStore.fromMap({
          "id": 2,
          "name": "test2",
          "address": "서울시 구로구 경인로",
          "businessPotential": "영업 가능성 낮아요",
        }),
        RecommendStore.fromMap({
          "id": 9,
          "name": "빽다방",
          "address": "서울시 구로구 고척동",
          "businessPotential": "영업 가능성 높아요",
        }),
      ];
    }
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
                margin: const EdgeInsets.all(24),
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
              const SizedBox(height: 40.0),
              Container(
                color: Color(0xFFFFFFFF),
                width: double.infinity,
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 Text
                    Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      child: Text(
                        recommendStoreCategory == "나이"
                        ? "$userAge대 추천 가게"
                        : "$userGender성 추천 가게",
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              recommendStoreCategory = '나이'; // 나이 선택
                              getRecommendStore();
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 58,
                            decoration: BoxDecoration(
                              color: recommendStoreCategory == '나이'
                                ? const Color(0xFFF15A2B) // 선택된 색상
                                : Colors.transparent, // 기본 색상
                              border: recommendStoreCategory == '나이'
                                ? null // 선택된 상태에서는 테두리 없음
                                : Border.all(
                                    color: const Color(0xFF767676), // 기본 테두리 색상
                                    width: 1, // 테두리 두께
                                ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "나이",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: recommendStoreCategory == '나이' ? Colors.white : const Color(0xFF767676),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              recommendStoreCategory = '성별'; // 성별 선택
                              getRecommendStore();
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 58,
                            decoration: BoxDecoration(
                              color: recommendStoreCategory == '성별'
                                  ? const Color(0xFFF15A2B) // 선택된 색상
                                  : Colors.transparent, // 기본 색상
                              border: recommendStoreCategory == '성별'
                                  ? null // 선택된 상태에서는 테두리 없음
                                  : Border.all(
                                color: const Color(0xFF767676), // 기본 테두리 색상
                                width: 1, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "성별",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: recommendStoreCategory == '성별' ? Colors.white : const Color(0xFF767676),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24,),
                    // API 통신으로 받아온 카드 3개 그리기
                    Container(
                      height: 400,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: _recommendStore.length,
                        itemBuilder: (context, index) {
                          var recommendStore = _recommendStore[index];
                          return GestureDetector(
                            onTap: () {
                              // 버튼이 눌리면 해당 점포 상세 페이지로 이동
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (BuildContext context) {
                              //       return StoreInfo(idx: addStore.id);
                              //     }));
                            },
                            child: Card(
                              elevation: 0,
                              color: const Color(0xFFF4F4F4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 18,
                                      backgroundImage:
                                      AssetImage('assets/images/icon.png'),
                                    ),
                                    const SizedBox(
                                      // 테스트용
                                      width: 30,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.baseline, // 기준선 정렬
                                          textBaseline: TextBaseline.alphabetic, // 알파벳 기준선 사용
                                          children: [
                                            Text(
                                              recommendStore.name,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              // 테스트용
                                              width: 8,
                                            ),
                                            Text(
                                              "103m",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF767676),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          // 테스트용
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.lightbulb_outline_rounded,
                                              size: 16,
                                              color: Color(0xFFF15A2B),
                                            ),
                                            SizedBox(width: 4,),
                                            Text(
                                              recommendStore.businessPotential,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF767676),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]
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
