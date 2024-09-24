import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'bookmark_view_model.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => BookmarkPageState();
}

class BookmarkPageState extends State<BookmarkPage> {
  BookmarkViewModel viewModel = BookmarkViewModel();
  late List<UserBookmark> _userBookmarkGetAPI = [
    UserBookmark(
      id: 0,
      storeName: "",
      storeId: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    getUserBookmark();
  }
  void getUserBookmark() async {
    _userBookmarkGetAPI = await viewModel.userBookmarkGetAPI();
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
      body: ListView.builder(
        itemCount: _userBookmarkGetAPI.length,
        itemBuilder: (context, index) {
          var bookmark = _userBookmarkGetAPI[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: ListTile(
              title: Text(bookmark.storeName),
              subtitle: Text('Store ID: ${bookmark.storeId}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // 아이템 클릭 시 동작할 코드
              },
            ),
          );
        },
      ),
    );
  }
}
