import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "마이 페이지",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView( // 스크롤
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5, // 예시: 높이 설정 (필요에 따라 조정)
              color: Color(0xFFF4F4F4),
              padding: EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Row(
                    children: [
                      // 프로필 사진
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage('assets/images/profile_img1.jpg'),
                      ),
                      SizedBox(width: 24), // 간격 조정
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                          children: [
                            // 칭호
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
                                "막 개장한 포장마차",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFF15A2B), // 텍스트 색상 유지
                                ),
                              ),
                            ),
                            SizedBox(height: 8), // 간격 조정
                            // 닉네임
                            Text(
                              "도도한 고양이",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40), // 간격 조정

                  Container(
                    height: 44,
                    width: double.infinity,
                    // 프로필 편집 버튼
                    child:  OutlinedButton(
                      onPressed: () {
                        // 프로필 편집 페이지 이동
                      },
                      child: Text(
                        '프로필 편집',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF767676),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 64), // 간격 조정

                  // 등록한 가게, 칭호, 선물함
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 등록한 가게
                      Text(
                        '등록한 가게',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF767676),
                        ),
                      ),
                      // 칭호
                      Text(
                        '칭호',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF767676),
                        ),
                      ),
                      // 선물함
                      // 칭호
                      Text(
                        '선물함',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF767676),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 내 칭호, 내가 쓴 리뷰, 북마크한 가게, 선물함?
            // 내 칭호 버튼
            SizedBox(
              height: 44, // 버튼의 높이를 44로 설정
              child: TextButton(
                onPressed: () {
                  // 내 칭호 페이지로 이동하는 코드
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 아이콘과 텍스트를 중앙에 배치
                  children: [
                    Text(
                      '내 칭호',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right, // 예시 아이콘, 필요에 따라 변경
                      color: Theme.of(context).primaryColor, // 아이콘 색상을 앱의 주 색상으로 설정
                    ),
                    SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
