import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTitle extends StatefulWidget {
  final int idx;
  const MainTitle({super.key, required this.idx});

  @override
  State<MainTitle> createState() => _MainTitleState();
}

class _MainTitleState extends State<MainTitle> {
  late final SetOpenPossbility;

  @override
  void initState() {
    super.initState();
    SetOpenPossbility = getOpenPossibility();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              storeData?.name ?? '이름이 없습니다',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Column(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                        size: 24,
                        CupertinoIcons.arrow_up_right_diamond_fill,
                        color: Color(0xffF15A2B))),
                const Text(
                  "{A}m",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 16,
              color: Color(0xffF15A2B),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              SetOpenPossbility ? "영업 가능성이 높아요!" : "영업 가능성이 있어요!",
              style: TextStyle(
                color: Color(0xFF767676),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        )
      ],
    );
  }

  bool getOpenPossibility() {
    if (storeData?.openPossibility == "HIGH") {
      return true;
    } else {
      return false;
    }
  }
}
