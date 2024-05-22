// main.dart
import 'package:flutter/material.dart';
import 'package:dongpo_test/models/pocha.dart';
import 'dart:convert'; // JSON 변환을 위해 import
import 'package:http/http.dart' as http; // HTTP 요청을 위해 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST API Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Jumpho> _jumphos = []; // Jumpho 객체들을 저장할 리스트

  // REST API로부터 데이터를 받아오는 함수
  Future<void> fetchJumphos() async {
    final response =
        await http.get(Uri.parse('https://example.com/api/jumphos'));

    // 응답이 성공적이면 (200 OK)
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body); // JSON 데이터를 디코드
      setState(() {
        // 디코드된 JSON 데이터를 Jumpho 객체로 변환하여 리스트에 저장
        _jumphos = jsonResponse.map((data) => Jumpho.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load Jumphos');
    }
  }

  // 데이터를 JSON으로 변환하여 POST 요청 보내는 함수
  Future<void> sendJumpho(Jumpho jumpho) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/jumphos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jumpho.toJson()), // Jumpho 객체를 JSON으로 변환하여 body에 포함
    );

    if (response.statusCode == 201) {
      print('Jumpho created successfully');
    } else {
      throw Exception('Failed to create Jumpho');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter REST API Example'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: fetchJumphos, // 버튼을 누르면 데이터를 가져옴
            child: Text('Load Jumphos'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _jumphos.length, // 리스트의 아이템 개수
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text(_jumphos[index].name ?? 'Unknown'), // Jumpho의 이름 출력
                  subtitle: Text(_jumphos[index].location ??
                      'No location'), // Jumpho의 위치 출력
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 예시 Jumpho 객체 생성
          Jumpho newJumpho = Jumpho(
            name: 'New Jumpho',
            location: 'Seoul',
            openTime: '09:00',
            closeTime: '18:00',
            memberId: 1,
            status: 'Open',
            operatingDays: ['Monday', 'Tuesday'],
            payMethods: ['Cash', 'Card'],
            toiletValid: true,
          );
          sendJumpho(newJumpho); // 새 Jumpho 데이터를 서버에 전송
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
