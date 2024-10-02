// title 클래스
class InfoUserTitle{
  late final String title;
  late final String description;
  late final String achieveCondition;
  late final DateTime achieveDate;

  InfoUserTitle({
    required this.title,
    required this.description,
    required this.achieveCondition,
    required this.achieveDate,
  });

  factory InfoUserTitle.fromJson(Map<String, dynamic> json) {
    return InfoUserTitle(
      title: json['title'],
      description: json['description'],
      achieveCondition: json['achieveCondition'],
      // String을 DateTime으로 변환
      achieveDate: DateTime.parse(json['achieveDate']),
    );
  }
}