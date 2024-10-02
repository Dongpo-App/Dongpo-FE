import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'package:dongpo_test/main.dart';
import 'bookmark_view_model.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => BookmarkPageState();
}

class BookmarkPageState extends State<BookmarkPage> {
  BookmarkViewModel viewModel = BookmarkViewModel();

  late List<UserBookmark> _userBookmark = [
  ];

  @override
  void initState() {
    super.initState();
    getUserBookmark();
  }
  void getUserBookmark() async {
    _userBookmark = await viewModel.userBookmarkGetAPI(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "북마크 한 가게",
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
      body: _userBookmark.isEmpty
        ? const Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 24),
            child: ListView.builder(
              itemCount: _userBookmark.length,
              itemBuilder: (context, index) {
                var bookmark = _userBookmark[index];
                return Card(
                  elevation: 0,
                  color: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 24
                  ),
                  child: SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(
                              'assets/images/icon.png'
                            ),
                          ),
                          SizedBox( // 테스트용
                            width: 30,
                          ),
                          Text(
                            _userBookmark[index].storeName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: (){
                              // 버튼이 눌리면 북마크 취소됨
                            },
                            icon: Icon(
                              Icons.bookmark_rounded,
                              size: 24,
                              color: Color(0xFFF15A2B),
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ),
    );
  }
}
