import 'dart:convert';
import 'package:http/http.dart' as http;

// 데이터 모델 클래스
class Post {
  final int id;
  final String title;
  final String body;
  final int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }
}

void main() async {
  final posts = await fetchPostData();
  posts.sort((a, b) => a.id.compareTo(b.id));

  for (final post in posts) {
    print('ID: ${post.id}, Title: ${post.title}');
  }
}

Future<List<Post>> fetchPostData() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);

    return jsonData.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch post data');
  }
}



// // //임의로 마커 여러개 생성
// List<MyData> generateDummyData() {
//   return [
//     MyData(
//       id: 1,
//       name: '가게 1',
//       latitude: 37.5021,
//       longitude: 126.8697,
//       openTime: '09:00:00',
//       closeTime: '21:00:00',
//       memberId: 1,
//       status: 'ACTIVE',
//       operatingDays: ['월', '화', '수', '목', '금'],
//       payMethods: ['카드', '현금'],
//       toiletValid: true,
//     ),
//     MyData(
//       id: 2,
//       name: '가게 2',
//       latitude: 37.5041,
//       longitude: 126.8668,
//       openTime: '10:00:00',
//       closeTime: '22:00:00',
//       memberId: 1,
//       status: 'ACTIVE',
//       operatingDays: ['월', '화', '수', '목', '금'],
//       payMethods: ['카드', '현금'],
//       toiletValid: false,
//     ),
//     MyData(
//       id: 3,
//       name: '가게 3',
//       latitude: 37.5051,
//       longitude: 126.8619,
//       openTime: '08:00:00',
//       closeTime: '20:00:00',
//       memberId: 1,
//       status: 'ACTIVE',
//       operatingDays: ['월', '화', '수', '목', '금'],
//       payMethods: ['카드', '현금'],
//       toiletValid: true,
//     ),
//     MyData(
//       id: 4,
//       name: '가게 4',
//       latitude: 37.5061,
//       longitude: 126.8630,
//       openTime: '11:00:00',
//       closeTime: '23:00:00',
//       memberId: 1,
//       status: 'ACTIVE',
//       operatingDays: ['월', '화', '수', '목', '금'],
//       payMethods: ['카드', '현금'],
//       toiletValid: false,
//     ),
//     MyData(
//       id: 5,
//       name: '가게 5',
//       latitude: 37.5071,
//       longitude: 126.8650,
//       openTime: '07:00:00',
//       closeTime: '19:00:00',
//       memberId: 1,
//       status: 'ACTIVE',
//       operatingDays: ['월', '화', '수', '목', '금'],
//       payMethods: ['카드', '현금'],
//       toiletValid: true,
//     ),
//   ];
// }

// List<MyData> myTestList = generateDummyData();

