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
            Text(
              "A(가게이름 출력)",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.arrow_up_right_diamond_fill,
                    color: Color(0xffF15A2B)))
          ],
        ),
        Text("{A} M"),
        Row(
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
