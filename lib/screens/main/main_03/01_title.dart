import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:dongpo_test/screens/main/main_03/main_03.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';

class MainTitle extends StatelessWidget {
  final int idx;
  const MainTitle({super.key, required this.idx});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              storeData?.name ?? '이름이 없습니다',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.arrow_up_right_diamond_fill,
                    color: Color(0xffF15A2B)))
          ],
        ),
        const Text("{A} M"),
        const Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Color(0xffF15A2B),
            ),
            Text("A(영업 가능성이 높아요!)")
          ],
        )
      ],
    );
  }
}
