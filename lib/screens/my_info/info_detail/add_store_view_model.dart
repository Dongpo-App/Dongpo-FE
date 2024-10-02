import 'dart:convert';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/user_bookmark.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AddStoreViewModel{


}

// user 예외 클래스 정의
class AddStoreException implements Exception {
  final String message;
  AddStoreException(this.message);

  @override
  String toString() => 'AddStoreException: $message';
}
