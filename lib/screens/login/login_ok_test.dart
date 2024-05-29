import 'package:flutter/material.dart';

class LoginOkPage extends StatefulWidget {
  const LoginOkPage({super.key});

  @override
  State<LoginOkPage> createState() => _LoginOkPageState();
}

class _LoginOkPageState extends State<LoginOkPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '로그인 완료'
        ),
      ),
    );
  }
}
