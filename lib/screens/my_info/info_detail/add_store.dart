import 'package:dongpo_test/screens/my_info/info_detail/add_store_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'bookmark_view_model.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({super.key});

  @override
  State<AddStorePage> createState() => AddStorePageState();
}

class AddStorePageState extends State<AddStorePage> {
  AddStoreViewModel viewModel = AddStoreViewModel();

  late final List<UserBookmark> _userBookmark = [];

  @override
  void initState() {
    super.initState();
    // getUserBookmark();
  }

  void getUserBookmark() async {
    // _userBookmark = await viewModel.userBookmarkGetAPI();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            "등록한 가게",
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
        body: const Center(
          child: Text(
            "테스트 페이지",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ));
  }
}
