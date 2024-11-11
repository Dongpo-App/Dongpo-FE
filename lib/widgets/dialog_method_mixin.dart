import 'package:flutter/material.dart';

mixin DialogMethodMixin<T extends StatefulWidget> on State<T> {
  // 확인 취소 버튼, 결과를 넘겨줄 수 있음
  Future<bool?> showChoiceDialog(BuildContext context,
      {required String title, required String message}) {
    // 확인 버튼
    Widget okButton = TextButton(
      child: const Text(
        "확인",
        style: TextStyle(
          color: Color(0xffF15A2B),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );

    // 취소 버튼
    Widget cancelButton = TextButton(
      child: const Text(
        "취소",
        style: TextStyle(
          color: Color(0xFF33393F),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    // 확인 버튼을 오른쪽
    // set up the AlertDialog
    // 완료되었을 때 Alert
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // 사용자에게 확인용
  void showAlertDialog(BuildContext context,
      {required String title, required String message}) {
    // 확인 버튼
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    // 완료되었을 때 Alert
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
