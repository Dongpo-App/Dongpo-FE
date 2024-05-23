import 'package:dongpo_test/screens/community/community.dart';
import 'package:flutter/material.dart';

class CommunityTop10Page extends StatefulWidget {
  final Top10TitleData top10TitleData;

  const CommunityTop10Page({required this.top10TitleData});

  @override
  State<CommunityTop10Page> createState() => CommunityTop10PageState();
}

class CommunityTop10PageState extends State<CommunityTop10Page> {
  List<Top10Data> top10Items = [
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
    Top10Data(
      member: '도도한 고양이',
      memberTitle: '난 한 가게만 패',
      memberProfile: 'assets/images/profile_img1.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.top10TitleData.top10Title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); //뒤로가기
          },
          color: Color(0xFF767676),
          icon: Icon(Icons.arrow_back)),
      ),
      body: ListView.builder(
        itemCount: top10Items.length,
        itemBuilder: (context, index){
          return Container(
            margin: EdgeInsets.all(24),
            child: Top10CardWidget(top10Items[index]),
          );
        },
      ),
    );
  }
}
class Top10CardWidget extends StatelessWidget {
  final Top10Data top10Data;

  Top10CardWidget(this.top10Data);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(top10Data.member),
            // 카드 내용 추가
          ],
        ),
      ),
    );
  }
}

// DTO
class Top10Data {
  final String member;
  final String memberTitle;
  final String memberProfile;

  Top10Data({
    required this.member,
    required this.memberTitle,
    required this.memberProfile,
  });
}
