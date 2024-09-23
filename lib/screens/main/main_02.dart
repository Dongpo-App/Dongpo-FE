import 'dart:async';

import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/api_key.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressSearchPage extends StatefulWidget {
  const AddressSearchPage({super.key});

  @override
  _AddressSearchPageState createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _results = [];
  Timer? _debounce;
  final String _apiKey = kakaoApiKey;
  final String baseUrl = "https://dapi.kakao.com/v2/local/search";
  final Map<String, List<dynamic>> _cache = {};

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 디바운스 적용 검색 함수
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      // 딜레이 시간 설정
      if (query.isNotEmpty) {
        _searchKeyword(query); // 디바운스 적용할 함수
      } else {
        setState(() {
          _results = [];
        });
      }
    });
  }

  Future<void> _searchAddress(String query) async {
    String url = '$baseUrl/address.json';
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

  // 키워드 검색 함수
  Future<void> _searchKeyword(String query) async {
    if (_cache.containsKey(query)) {
      setState(() {
        _results = _cache[query]!;
      });
      return;
    }

    String url = "$baseUrl/keyword.json";
    final headers = {'Authorization': 'KakaoAK $_apiKey'};
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final response = await http.get(
          Uri.parse(
              '$url?query=$query&x=${position.longitude}&y=${position.latitude}'),
          headers: headers);

      if (response.statusCode == 200) {
        logger.d(response.body);
        final data = json.decode(response.body);
        setState(() {
          _results = data['documents'] ?? [];
        });
      } else {
        throw Exception(
            'Failed to load recommand keywords ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Error: $e");
    }
  }

  // 미터 단위 변환 및 소수점 슬라이싱
  String alterDistance(String meter) {
    if (meter == "") {
      throw Exception("현재 위치 정보가 확인되지 않거나 오류가 발생");
    }
    double number = double.parse(meter);
    String distance = "";
    if (number > 1000) {
      // km
      number /= 1000;
      if (number < 10) {
        // 10km 미만이면 소수점 한 자리
        distance = "${number.toStringAsFixed(1)}km";
      } else {
        // 10km 이상이면 소수점 제거
        distance = "${number.toStringAsFixed(0)}km";
      }
    } else {
      // m
      distance = "${number.toStringAsFixed(0)}m";
    }
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카카오맵 주소 검색'),
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
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchKeyword(_controller.text);
                  },
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (value) {
                //_searchKeyword(value);
              },
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black12,
                  );
                },
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return ListTile(
                    title: Text(item['place_name']),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['address_name']),
                        Text(alterDistance(item['distance'])),
                      ],
                    ),
                    onTap: () {
                      Map data = {
                        'lat': item['y'],
                        'lng': item['x'],
                      };
                      Navigator.pop(context, data);
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => AlertDialog(
                      //     title: const Text('위치 정보'),
                      //     content: Text('위도: $lat\n경도: $lng'),
                      //     actions: [
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.of(context).pop();
                      //         },
                      //         child: const Text('확인'),
                      //       ),
                      //     ],
                      //   ),
                      // );
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
