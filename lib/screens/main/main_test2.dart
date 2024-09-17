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
