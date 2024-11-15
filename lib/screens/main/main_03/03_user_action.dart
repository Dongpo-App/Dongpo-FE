import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../models/store/store_detail.dart';
import '../../login/login_view_model.dart';
import '05_all_reviews.dart';

//북마크, 리뷰 댓글
//만약 내가 북마크를 해놓은 상태라면
//북마크 추가 아이콘 + 버튼 누를시 해지
//아니라면
//북마크 아이콘 + 버튼 누를시 추가

//내려갔다 올라가면 북마크 다시 초기화되어있는 오류있음
class UserAction extends StatefulWidget {
  final int idx;
  final List<Review> reviewList;

  const UserAction({
    super.key,
    required this.idx,
    required this.reviewList,
  });

  @override
  State<UserAction> createState() => _UserActionState();
  //북마크 추가
}

class _UserActionState extends State<UserAction> {
  MapManager manager = MapManager();
  int? userActionCount = 0;
  @override
  void initState() {
    super.initState();
    checkedBookMark();
    userActionCount = manager.selectedDetail?.bookmarkCount;
  }

  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    logger.d("userActionCount : $userActionCount");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowAllReviews(idx: widget.idx, reviewList: widget.reviewList,),
                  )
              );
            },
            icon: const Icon(
              Icons.chat,
              color: Color(0xFF767676),
              size: 24,
            ),
          ),
          Text(
            "${widget.reviewList.length}",
            style: const TextStyle(
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
                      userActionCount = (userActionCount ?? 0) - 1;
                    });
                    removeBookMark();
                  },
                  icon: const Icon(
                    Icons.bookmark_rounded,
                    size: 24,
                  ),
                  style: ButtonStyle(
                      iconColor: WidgetStateColor.resolveWith(
                          (states) => const Color(0xffF15A2B))),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _selected = true;
                      userActionCount = (userActionCount ?? 0) + 1;
                    });
                    addBookMark();
                  },
                  icon: const Icon(
                    Icons.bookmark_rounded,
                    size: 24,
                    color: Color(0xFF767676),
                  ),
                ),
          Text("$userActionCount"),
        ],
      ),
    );
  }

  void checkedBookMark() async {
    final url = Uri.parse('$serverUrl/api/my-page/bookmarks');
    final accessToken = await storage.read(key: 'accessToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        // JSON 데이터 디코딩 및 UTF-8 디코딩
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));

        // 서버에서 받은 데이터 중 'data' 키의 값을 리스트로 가져옴
        final List<dynamic> jsonData = data['data'];

        // JSON 배열을 UserBookmark 리스트로 변환
        userBookmark = jsonData
            .map((jsonItem) => UserBookmark.fromJson(jsonItem))
            .toList();

        logger.d("checkBookMark isSelected : $data");

        checkBookMark();

        logger.d("북마크 체크 완료 현재 selected 값 : $_selected");
      } else {
        logger
            .e("Failed to load bookmarks. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // TODO
      logger.d('eeror! : $e');
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
    final url =
        Uri.parse('$serverUrl/api/bookmark/${manager.selectedDetail?.id}');
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
    for (int i = 1; i < userBookmark.length; i++) {
      if (userBookmark[i].storeId == widget.idx) {
        setState(() {
          _selected = true;
        });
      }
    }
  }
}
