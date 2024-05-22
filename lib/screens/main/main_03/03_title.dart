import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text("제목"),
            Spacer(),
            IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.arrow_up_right_diamond_fill,
                    color: Color(0xffF15A2B)))
          ],
        ),
        Text("103M"),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Color(0xffF15A2B),
            ),
            Text("영업 가능성 높아요!")
          ],
        )
      ],
    );
  }
}
