import 'dart:ui';

import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../login/login_view_model.dart';

//북마크, 리뷰 댓글
//만약 내가 북마크를 해놓은 상태라면
//북마크 추가 아이콘 + 버튼 누를시 해지
//아니라면
//북마크 아이콘 + 버튼 누를시 추가

//내려갔다 올라가면 북마크 다시 초기화되어있는 오류있음
class UserAction extends StatefulWidget {
  final int idx;
  const UserAction({super.key, required this.idx});

  @override
  State<UserAction> createState() => _UserActionState();
  //북마크 추가
}

class _UserActionState extends State<UserAction> {
  @override
  void initState() {
    super.initState();
    checkBookMark();
  }

  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.chat,
            color: Color(0xFF767676),
            size: 24,
          ),
        ),
        Text(
          "${storeData?.reviews.length}",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF767676)),
        ),
        const SizedBox(
          width: 16,
        ),
        const Text("|",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF767676))),
        //북마크 추가를 기존에 했었다면
        _selected
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _selected = false;
                  });
                  removeBookMark();
                },
                icon: const Icon(
                  Icons.bookmark_rounded,
                  size: 24,
                ),
                style: ButtonStyle(
                    iconColor: WidgetStateColor.resolveWith(
                        (states) => Color(0xffF15A2B))),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    _selected = true;
                  });
                  addBookMark();
                },
                icon: const Icon(
                  Icons.bookmark_rounded,
                  size: 24,
                  color: Color(0xFF767676),
                ),
              ),
        const Text("(A)북마크 수"),
      ],
    );
  }

  void checkBookMarkSelected() async {
    final url = Uri.parse('$serverUrl/api/my-page/bookmarks');

    final accessToken = await storage.read(key: 'accessToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
      } else {
        logger.e(
            'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : ${response.body}');
      }
    } catch (e) {
      logger.e("에러!! 에러내용 : $e");
    }
  }

  void checkedBookMark() async {
    final url = Uri.parse('$serverUrl/api/my-page/bookmarks');
    final accessToken = await storage.read(key: 'accessToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      logger.d('ck 완료');
    }
  }

  void addBookMark() async {
    final url = Uri.parse('$serverUrl/api/bookmark/${widget.idx}');
    final accessToken = await storage.read(key: 'accessToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.post(url, headers: headers);
    final responseData = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      logger.d("북마크 동작 성공");
      logger.d('북마크 추가된 ID: ${widget.idx}');
    } else {
      logger.e(
          'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : $responseData');
      throw Exception('HTTP ERROR !!! $responseData');
    }
  }

  void removeBookMark() async {
    final url = Uri.parse('$serverUrl/api/bookmark/${storeData?.id}');
    final accessToken = await storage.read(key: 'accessToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.delete(url, headers: headers);

    final data = json.decode(utf8.decode(response.bodyBytes)); // UTF-8 디코딩

    if (response.statusCode == 200) {
      logger.d("북마크 삭제 완료");
    } else {
      logger.e('HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : $data');
      throw Exception('HTTP ERROR !!! $data');
    }
  }

  void checkBookMark() {
    for (int i = 0; i < userBookmark.length; i++) {
      if (userBookmark[i].storeId == widget.idx) {
        _selected = true;
        logger.d('북마크한 가게');
      }
    }
    logger.d('북마크 체크 완료');
    setState(() {});
  }
}
