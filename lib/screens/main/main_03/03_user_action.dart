import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAction extends StatefulWidget {
  const UserAction({super.key});

  @override
  State<UserAction> createState() => _UserActionState();
}

class _UserActionState extends State<UserAction> {
  bool _selected = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chat),
        ),
        const Text("A"),
        const SizedBox(
          width: 10,
        ),
        const Text("|", style: TextStyle(fontSize: 21)),
        //북마크 추가를 기존에 했었다면
        _selected
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _selected = false;
                  });
                },
                icon: const Icon(Icons.bookmark_added),
                style: ButtonStyle(
                    iconColor: WidgetStateColor.resolveWith(
                        (states) => Colors.orange)),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    _selected = true;
                  });
                },
                icon: const Icon(Icons.bookmark),
              ),
        const Text("A"),
      ],
    );
  }
}
//24
