// title 클래스
class UserTitle{
  late final String title;
  late final String description;

  UserTitle({
    required this.title,
    required this.description,
  });

  factory UserTitle.fromJson(Map<String, dynamic> json) {
    return UserTitle(
      title: json['title'],
      description: json['description'],
    );
  }
}