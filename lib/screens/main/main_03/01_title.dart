import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  final int idx;
  const MainTitle({super.key, required this.idx});

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
                      color: Color(0xffF15A2B)
                  )
                ),
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
        const Row(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 16,
              color: Color(0xffF15A2B),
            ),
            SizedBox(width: 8,),
            Text(
              "A(영업 가능성이 높아요!)",
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
}
