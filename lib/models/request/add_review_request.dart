class AddReviewRequest {
  final int reviewStar;
  final String reviewText;
  final List<String>? reviewPics;

  AddReviewRequest({
    required this.reviewStar,
    required this.reviewText,
    required this.reviewPics,
  });

  Map<String, dynamic> toJson() {
    return {
      'reviewStar': reviewStar,
      'reviewText': reviewText,
      'reviewPics': (reviewPics != null) ? reviewPics : [],
    };
  }
}
