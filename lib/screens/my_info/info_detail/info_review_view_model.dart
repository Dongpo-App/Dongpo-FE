import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class InfoReviewViewModel{
  // secure storage
  static const storage = FlutterSecureStorage();

}

// user 예외 클래스 정의
class InfoReviewViewException implements Exception {
  final String message;
  InfoReviewViewException(this.message);

  @override
  String toString() => 'InfoReviewViewException: $message';
}
