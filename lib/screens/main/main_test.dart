import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 모델 클래스
class Shop {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String openTime;
  final String closeTime;
  final int memberId;
  final String status;
  final List<String> operatingDays;
  final List<String> payMethods;
  final bool toiletValid;

  Shop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.openTime,
    required this.closeTime,
    required this.memberId,
    required this.status,
    required this.operatingDays,
    required this.payMethods,
    required this.toiletValid,
  });

  // JSON 데이터를 모델 클래스로 변환하는 팩토리 메서드
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      memberId: json['memberId'],
      status: json['status'],
      operatingDays: List<String>.from(json['operatingDays']),
      payMethods: List<String>.from(json['payMethods']),
      toiletValid: json['toiletValid'],
    );
  }
}

// GET 요청을 통해 데이터를 받아오는 함수
Future<List<Shop>> fetchShops() async {
  final response = await http.get(Uri.parse('https://example.com/api/shops'));

  // 응답이 성공적인 경우
  if (response.statusCode == 200) {
    // JSON 데이터를 파싱하여 Shop 객체 리스트로 변환
    final List<dynamic> data = jsonDecode(response.body)['data'];
    return data.map((json) => Shop.fromJson(json)).toList();
  } else {
    // 요청이 실패한 경우 예외를 던짐
    throw Exception('Failed to load shops');
  }
}

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  _ShopListScreenState createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  late Future<List<Shop>> futureShops;

  @override
  void initState() {
    super.initState();
    // 페이지가 로드될 때 fetchShops 함수를 호출하여 데이터를 불러옴
    futureShops = fetchShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop List'),
      ),
      body: FutureBuilder<List<Shop>>(
        future: futureShops,
        builder: (context, snapshot) {
          // 데이터가 로드되는 동안 로딩 스피너를 표시
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 데이터 로드가 완료된 경우
          else if (snapshot.hasData) {
            // 데이터가 없는 경우
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No shops available'));
            }
            // 데이터가 있는 경우 리스트뷰로 표시
            else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final shop = snapshot.data![index];
                  return ListTile(
                    title: Text(shop.name),
                    subtitle: Text(
                        'Open: ${shop.openTime}, Close: ${shop.closeTime}'),
                  );
                },
              );
            }
          }
          // 데이터 로드 중 오류가 발생한 경우
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // 기타 경우
          else {
            return const Center(child: Text('Unexpected error'));
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ShopListScreen(),
  ));
}
