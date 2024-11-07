import 'dart:io';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

mixin ErrorHandlingMixin<T extends StatefulWidget> on State<T> {
  // 예외 처리
  void handleError(Object error, BuildContext context) {
    if (error is SocketException) {
      logger.e("network error", error: error);
    } else if (error is TokenExpiredException) {
      logger.e(error.toString(), error: error);
    } else if (error is HttpException) {
      logger.e("http error", error: error);
    } else if (error is FormatException) {
      logger.e("format error", error: error);
    } else if (error is ServerLogoutException) {
      logger.e(error.toString(), error: error);
    } else if (error is AccountDeletionFailureException) {
      logger.e(error.toString(), error: error);
    } else {
      logger.e("unknown error", error: error);
    }
  }

  void showAlert(BuildContext context, String message) {
    // set up the button
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    // 완료되었을 때 Alert
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("알림"),
      content: Text(message),
      actions: [
        Center(child: okButton),
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

  void _handleTokenExpired(BuildContext context) {
    // 토큰 삭제 로직
    // 로그인 화면으로 이동
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _handleLogoutFailure(BuildContext context) {
    // 토큰 삭제 로직
    // 로그인 화면으로 이동
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
