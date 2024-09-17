import 'package:flutter/material.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:dongpo_test/screens/add/add_01.dart';
import 'package:dongpo_test/screens/community/community.dart';
import 'package:dongpo_test/screens/my_info/info.dart';

class MyAppPage extends StatefulWidget {
  final int initialIndex;
  const MyAppPage({super.key, this.initialIndex = 0});

  @override
  State<MyAppPage> createState() => MyAppPageState();
}

class MyAppPageState extends State<MyAppPage> {
  late int selectedIndex;

  final List<Widget> screens = [
    const MainPage(),
    const AddPage(),
    const CommunityPage(),
    const MyPage(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void onItemTapped(int index) {
    // 콜백 함수
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height; // 현재 화면 높이
    // final bottomNavHeight = screenHeight * 0.08; // 화면 높이의 8%
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SizedBox(
        // height: bottomNavHeight,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account),
              label: '',
            ),
          ],
          iconSize: 24,
          currentIndex: selectedIndex,
          selectedItemColor: const Color(0xffF15A2B), // 클릭 시 변경할 색상
          unselectedItemColor: const Color(0xff767676), // 클릭되지 않은 아이콘 색상
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed, // 메뉴 아이템 고정 크기
          showSelectedLabels: false, // 라벨 감추기
          showUnselectedLabels: false, // 라벨 감추기
          enableFeedback: false, // 선택 시 효과음 X
        ),
      ),
    );
  }
}
