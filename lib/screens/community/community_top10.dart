import 'package:dongpo_test/screens/community/community.dart';
import 'package:flutter/cupertino.dart';
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
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
            margin: EdgeInsets.only(left: 24, top: 12, bottom: 12, right: 24),
            child: Top10CardWidget(top10Items[index], index),
          );
        },
      ),
    );
  }
}

class Top10CardWidget extends StatelessWidget {
  final Top10Data top10Data;
  final int index;

  Top10CardWidget(this.top10Data, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: 80, // 세로 크기 80
        child: Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '${index + 1}등',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ClipOval(
                child: Image.asset(
                  top10Data.memberProfile,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5E0D9),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Color(0xFFF5E0D9), // 테두리 색상
                        ),
                      ),
                      child: Text(
                        top10Data.memberTitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF15A2B), // 텍스트 색상 유지
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      top10Data.member,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
