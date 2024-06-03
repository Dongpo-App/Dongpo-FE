import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressSearchPage extends StatefulWidget {
  @override
  _AddressSearchPageState createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _results = [];
  String _apiKey = kakaoApiKey;

  Future<void> _searchAddress(String query) async {
    final url = 'https://dapi.kakao.com/v2/local/search/address.json';
    final headers = {'Authorization': 'KakaoAK $_apiKey'};
    final response =
        await http.get(Uri.parse('$url?query=$query'), headers: headers);

    if (response.statusCode == 200) {
      logger.d(response.body);
      final data = json.decode(response.body);
      setState(() {
        _results = data['documents'];
      });
    } else {
      throw Exception('Failed to load address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카카오맵 주소 검색'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '주소를 입력하세요',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchAddress(_controller.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                _searchAddress(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return ListTile(
                    title: Text(item['address_name']),
                    onTap: () {
                      final lat = item['y'];
                      final lng = item['x'];
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('위치 정보'),
                          content: Text('위도: $lat\n경도: $lng'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('확인'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
