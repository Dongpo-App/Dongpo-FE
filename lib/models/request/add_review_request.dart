class AddReviewRequest {
  final int reviewStar;
  final String text;
  final List<String>? reviewPics;

  AddReviewRequest({
    required this.reviewStar,
    required this.text,
    required this.reviewPics,
  });

  Map<String, dynamic> toJson() {
    return {
      'reviewStar': reviewStar,
      'text': text,
      'reviewPics': (reviewPics != null) ? reviewPics : [],
    };
  }
}
