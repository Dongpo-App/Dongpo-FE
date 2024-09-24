import 'package:dongpo_test/screens/community/community.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/community_rack.dart';

class CommunityTop10Page extends StatefulWidget {
  final Top10TitleData top10TitleData;
  final List<CommunityRank> top10List;

  const CommunityTop10Page({
    super.key,
    required this.top10TitleData,
    required this.top10List,
  });

  @override
  State<CommunityTop10Page> createState() => CommunityTop10PageState();
}

class CommunityTop10PageState extends State<CommunityTop10Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          widget.top10TitleData.top10Title,
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
      body: ListView.builder(
        itemCount: widget.top10List.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 24, top: 12, bottom: 12, right: 24),
            child: Top10CardWidget(
              top10Data: Top10Data(
                member: widget.top10List[index].nickname,
                memberTitle: widget.top10List[index].title,
                memberProfile: widget.top10List[index].pic,
              ),
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class Top10CardWidget extends StatelessWidget {
  final Top10Data top10Data;
  final int index;

  const Top10CardWidget({super.key, required this.top10Data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: 80, // 세로 크기 80
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '${index + 1}등',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundImage: (top10Data.memberProfile != null && top10Data.memberProfile!.isNotEmpty)
                    ? NetworkImage(top10Data.memberProfile!) as ImageProvider
                    : const AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E0D9),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: const Color(0xFFF5E0D9), // 테두리 색상
                        ),
                      ),
                      child: Text(
                        top10Data.memberTitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF15A2B), // 텍스트 색상 유지
                        ),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      top10Data.member,
                      style: const TextStyle(
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
  final String? memberProfile;

  Top10Data({
    required this.member,
    required this.memberTitle,
    required this.memberProfile,
  });
}
