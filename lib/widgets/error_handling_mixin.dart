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

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
