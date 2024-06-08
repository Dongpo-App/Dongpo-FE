import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../login/login_test2.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 48, left: 24, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 프로필 사진
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/images/profile_img1.jpg'),
                  ),
                  SizedBox(width: 16), // 간격 조정
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
            ),
            SizedBox(height: 40), // 간격 조정
            Container(
              height: 44,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24),
              // 프로필 편집 버튼
              child:  OutlinedButton(
                onPressed: () {
                  // 프로필 편집 페이지 이동
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    )
                  )
                ),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical : 24),
              child: Row(
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
            ),
            SizedBox(
              height: 24,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFF4F4F4),
                ),
              ),
            ),
            // 내 칭호, 내가 쓴 리뷰, 북마크한 가게, 선물함
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: Text(
                  '내 칭호',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF767676)
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  // 내 칭호 버튼이 클릭되었을 때의 액션
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: Text(
                  '내가 쓴 리뷰',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF767676)
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  // 내가 쓴 리뷰 버튼이 클릭되었을 때의 액션
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: Text(
                  '북마크한 가게',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF767676)
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  // 북마크한 가게 버튼이 클릭되었을 때의 액션
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: Text(
                  '선물함',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF767676)
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  // 선물함 버튼이 클릭되었을 때의 액션
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()
                ));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                color: Color(0xFFF4F4F4),
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF767676),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
