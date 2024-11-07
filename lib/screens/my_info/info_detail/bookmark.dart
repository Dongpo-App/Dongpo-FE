import 'package:flutter/material.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import '../../main/main_03/main_03.dart';
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
  void deleteUserBookmark(int storeId) async {
    bool isBookmarkDeleted = await viewModel.userBookmarkDeleteAPI(context, storeId);
    if (isBookmarkDeleted && mounted) {
      setState(() {
        getUserBookmark();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "북마크 한 가게",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
        : ListView.builder(
            padding: const EdgeInsets.only(top: 24),
            itemCount: _userBookmark.length,
            itemBuilder: (context, index) {
              var bookmark = _userBookmark[index];
              return GestureDetector(
                onTap: () {
                  // 버튼이 눌리면 해당 점포 상세 페이지로 이동
                  Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return StoreInfo(idx: bookmark.storeId);
                  }));
                },
                child: Card(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(
                              'assets/images/icon.png'
                            ),
                          ),
                          const SizedBox( // 테스트용
                            width: 30,
                          ),
                          Text(
                            bookmark.storeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              // 버튼이 눌리면 북마크 취소됨
                              deleteUserBookmark(bookmark.storeId);
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center, // 아이콘이 가운데에 오도록 설정
                              child: const Icon(
                                Icons.bookmark_rounded,
                                size: 24,
                                color: Color(0xFFF15A2B),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
        ),
    );
  }
}
