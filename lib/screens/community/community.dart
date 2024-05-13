import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Color(0xFFF4F4F4),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 Text
          Padding(
            padding: EdgeInsets.only(top: 24.0, left: 24.0),
            child: Text(
              "별별 사람들",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600
              ),
            )
          ),

          SizedBox(height: 48.0),
          // 조건 Top 10 카드 슬라이드
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 24.0), // 왼쪽 24 margin
                _buildCard(
                  top10Title: '방문 인증 횟수 top 10',
                  member: '도도한 고양이',
                  memberTitle: '난 한 가게만 패',
                  memberProfile: 'assets/images/profile_img1.jpg',
                ),
                SizedBox(width: 34.0), // 카드 사이의 거리
                _buildCard(
                  top10Title: '가게 등록 횟수 top 10',
                  member: '친절한 강아지',
                  memberTitle: '포장마차 러버',
                  memberProfile: 'assets/images/profile_img2.png',
                ),
                SizedBox(width: 34.0),
                _buildCard(
                  top10Title: '가게 리뷰 횟수 top 10',
                  member: '행복한 참새',
                  memberTitle: '애미야 국이 짜다',
                  memberProfile: 'assets/images/profile_img3.png',
                ),
                SizedBox(width: 34.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 조건 Top 10 카드 슬라이드 3개
  Widget _buildCard({required String top10Title, required String member, required String memberTitle, required String memberProfile}) {
    return Container( //
      width: 260.0,
      height: 213.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              top10Title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: 48,
              child: Image.asset(memberProfile),
            ),
            Text(
              memberTitle,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              member,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}