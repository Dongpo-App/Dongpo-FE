import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAction extends StatelessWidget {
  const UserAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.reviews),
        ),
        Text("31"),
        SizedBox(
          width: 10,
        ),
        Text("|", style: TextStyle(fontSize: 21)),
        IconButton(onPressed: () {}, icon: Icon(Icons.bookmark)),
        Text("31"),
      ],
    );
  }
}
