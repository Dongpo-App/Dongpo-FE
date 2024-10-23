import 'dart:convert';
import 'dart:io';
import 'package:dongpo_test/screens/login/login.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:dongpo_test/service/store_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dongpo_test/main.dart';
import 'package:http/http.dart' as http;

int value = 0;

class ShowReview extends StatefulWidget {
  final int idx;
  const ShowReview({super.key, required this.idx});

  @override
  State<ShowReview> createState() => _ShowReviewState();
}

//사진 관련
class _ShowReviewState extends State<ShowReview> {
  //static const storage = FlutterSecureStorage();
  StoreApiService storeService = StoreApiService.instance;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final reviewList = storeData?.reviews ?? []; // null일 경우 빈 리스트로 대체

//여기서 부터 화면
  @override
  Widget build(BuildContext context) {
    int storeId = widget.idx;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "리뷰 A개",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Column(
                              children: [
                                //상단 1
                                Row(
                                  children: [
                                    const Text(
                                      "방문 후기를 알려주세요",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        _showConfirmationDialog(context);
                                      },
                                      icon: const Icon(CupertinoIcons.xmark,
                                          color: Colors.black, size: 30),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                //별점 RatingBar //상단 2
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      minRating: 0.5,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      glowRadius: 1,
                                      glow: false,
                                      itemPadding: EdgeInsets.zero,
                                      itemSize: 60,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Color(0xffF15A2B),
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          _rating = rating.floor();
                                          logger.d(rating);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                //사진 첨부 텍스트 //상단 3
                                const Row(
                                  children: [
                                    Text(
                                      "사진 첨부",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(" 최대 3개까지 선택 가능해요"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // 사진 첨부 버튼과 이미지 미리보기 //상단 4
                                Row(
                                  children: List.generate(
                                    3,
                                    (index) => Container(
                                      margin: const EdgeInsets.all(5),
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: index < _pickedImgs.length
                                                ? Colors.transparent
                                                : Colors.white70,
                                            width: 1),
                                        image: index < _pickedImgs.length
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                  File(_pickedImgs[index].path),
                                                ),
                                              )
                                            : null,
                                      ),
                                      child: index == _pickedImgs.length
                                          ? _addPhotoButton(setState)
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                //텍스트 필드 (200글자 이내로 작성해주세요!) //상단 5
                                SizedBox(
                                  height: 200,
                                  child: TextField(
                                    controller: _reviewController,
                                    maxLength: 200,
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '200 글자 이내로 적어주세요!',
                                    ),
                                  ),
                                ),

                                //바닥에 리뷰 등록 버튼 (form전송)
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await storeService.addReview(
                                        id: storeId,
                                        reviewText: _reviewController.text,
                                        images: _pickedImgs,
                                        rating: _rating,
                                      );
                                    } on TokenExpiredException catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "세션이 만료되었습니다. 다시 로그인해주세요.")));
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      } else {
                                        logger.e(
                                            "Error! while replace to Login page");
                                        logger.e("message: $e");
                                      }
                                    } on Exception catch (e) {
                                      logger.e("Error! message: $e");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    backgroundColor: const Color(0xffF15A2B),
                                  ),
                                  child: const Text(
                                    "리뷰 등록",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: const Color(0xffF15A2B),
              ),
              child: const Text(
                '리뷰 등록',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 40),
          const SizedBox(height: 40),
          //showReview 넣을 곳

          reviewList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true, // 높이를 자동으로 조정
                  physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
                  itemCount: reviewList.length,
                  itemBuilder: (context, index) {
                    final review =
                        reviewList[index].reviewStar; // 항상 비어있지 않으므로 직접 접근
                    logger.d('리뷰 리스트에 들어있는 값 체크 : $reviewList');

                    return _showReview(
                        context, review ?? 1, index); // 각 리뷰 위젯 생성
                  },
                )
              : Container(
                  child: const Center(
                    child: Text('리뷰가 아직 없습니다'),
                  ),
                ), // 리뷰가 없을 경우 빈 컨테이너 또는 메시지를 반환

          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShowAllReviews(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: const Color(0xffF15A2B),
              ),
              child: const Text(
                '리뷰 더보기',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addPhotoButton(setState) {
    return IconButton(
      onPressed: () {
        _pickImg(setState);
      },
      icon: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange, width: 1),
        ),
        child: const Icon(
          CupertinoIcons.camera,
          color: Colors.orange,
          size: 30,
        ),
      ),
    );
  }

  void _resetReview() {
    setState(() {
      _pickedImgs = [];
      _rating = 0;
      _reviewController.clear();
    });
  }

  //리뷰 컨펌
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('리뷰 작성을 종료하시겠습니까?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('저장된 정보가 전부 사라집니다!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('네'),
              onPressed: () {
                _resetReview();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //이미지 가져오기
  Future<void> _pickImg(setState) async {
    final List<XFile> images = await _picker.pickMultiImage(
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );
    setState(() {
      _pickedImgs = images.take(3).toList(); // 최대 3장까지 추가 가능
    });
  }
  //서버에서 url 받아와야함
  // Future<List<String>> uploadImages(List<XFile> images) async {
  //   final accessToken = await storage.read(key: 'accessToken');
  //   final uri = Uri.parse('$serverUrl/api/file-upload');
  //   var request = http.MultipartRequest('POST', uri);

  //   // Add Authorization token to the headers
  //   request.headers['Authorization'] = 'Bearer $accessToken';

  //   // Add images to the request
  //   for (var image in images) {
  //     request.files.add(await http.MultipartFile.fromPath('image', image.path));
  //   }
  //   logger.d(request);
  //   // Send request and get response
  //   final response = await request.send();
  //   if (response.statusCode == 200) {
  //     final responseData = await http.Response.fromStream(response);
  //     final jsonData = jsonDecode(responseData.body);
  //     logger.d('upload image 함수 작동');
  //     return List<String>.from(jsonData['data']['imageUrl']);
  //   } else {
  //     throw Exception('Failed to upload images');
  //   }
  // }

  //Review 추가 파트
  // Future<List<String>> uploadImages(List<XFile> images) async {
  //   final accessToken = await storage.read(key: 'accessToken');
  //   final uri = Uri.parse('$serverUrl/api/file-upload');
  //   var request = http.MultipartRequest('POST', uri);

  //   // Add Authorization token to the headers
  //   request.headers['Authorization'] = 'Bearer $accessToken';

  //   // Add images to the request
  //   for (var image in images) {
  //     request.files.add(await http.MultipartFile.fromPath('image', image.path));
  //   }

  //   // Send the request and get the response
  //   final response = await request.send();
  //   if (response.statusCode == 200) {
  //     final responseData = await http.Response.fromStream(response);
  //     final jsonData = jsonDecode(responseData.body);

  //     // Check if the data contains a list of image URLs
  //     if (jsonData['data'] is List) {
  //       // Extract the image URLs from the response
  //       List<String> imageUrls = (jsonData['data'] as List)
  //           .map((item) => item['imageUrl'].toString())
  //           .toList();
  //       logger.d(imageUrls);
  //       return imageUrls;
  //     } else {
  //       throw Exception('Unexpected response format');
  //     }
  //   } else {
  //     throw Exception('Failed to upload images');
  //   }
  // }

  // Future<void> submitReview(
  //     String reviewText, List<String> imageUrls, int rating) async {
  //   final accessToken = await storage.read(key: 'accessToken');
  //   final url = Uri.parse('$serverUrl/api/store/review/${widget.idx}');
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $accessToken',
  //   };
  //   logger.d('imageUrls = $imageUrls');

  //   // Create review data
  //   final data = {
  //     'text': reviewText,
  //     'reviewPics': imageUrls, // Use image URLs from the upload
  //     'reviewStar': rating, // Ensure the rating is an integer
  //   };

  //   logger.d('submitReview 함수 들어옴 (서버 통신 전)');
  //   // Send review request
  //   final response =
  //       await http.post(url, headers: headers, body: jsonEncode(data));
  //   try {
  //     if (response.statusCode == 200) {
  //       showAlertDialog(context);
  //     }
  //   } on Exception catch (e) {
  //     // TODO
  //   }
  // }

  // Future<void> _addReview(
  //     String reviewText, List<XFile> images, int rating) async {
  //   try {
  //     // 1. Upload images and get their URLs
  //     List<String> imageUrls = await uploadImages(images);
  //     logger.d('step 1 클리어 ');
  //     // 2. Submit review with the received image URLs
  //     await submitReview(reviewText, imageUrls, rating.toInt());
  //     logger.d('step 2 클리어');
  //   } catch (e) {
  //     // Handle error
  //     logger.d('Error !! $e');
  //   }
  // }
  // ---------- Review 추가 파트 끝 -----------

//리뷰 등록 클릭시 실행 함수

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("확인"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("리뷰 등록"),
      content: const Text("리뷰 등록이 완료되었습니다."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// 개별 리뷰를 표시하는 함수
  Widget _showReview(BuildContext context, int rating, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('${reviewList[index].memberProfilePic}'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('이름'),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red[100],
                          ),
                          child: Text(
                            "난 한 가게만 패",
                            style: TextStyle(
                                fontSize: 10, color: Colors.redAccent[400]),
                          ),
                        ),
                      ],
                    ),
                    RatingWidget(
                        rating: reviewList[index].reviewStar ?? 0), // 별점 위젯 추가
                  ],
                ),
              ],
            ),
            Text('${reviewList[index].text}'),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  Image(image: AssetImage('assets/images/rakoon.png')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('${reviewList[index].registerDate}'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "리뷰 신고하기",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            setState(() => value = 0);
                                            Navigator.pop(context);
                                          },
                                          icon:
                                              const Icon(CupertinoIcons.xmark))
                                    ],
                                  ),
                                  //버튼 모음
                                  Container(
                                    height: 350,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _radioBtn('홍보성 리뷰에요', 1, setState),
                                        _radioBtn('도배 글이에요', 2, setState),
                                        _radioBtn('부적절한 내용이에요(욕설, 선정적 내용 등)', 3,
                                            setState),
                                        _radioBtn('가게에 무관한 리뷰에요', 4, setState),
                                        _radioBtn('기타', 5, setState),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              (value == 0)
                                                  ? null
                                                  : logger.d('버튼 활성화');
                                              //dio.post()구현
                                            },
                                            style: ElevatedButton.styleFrom(
                                              splashFactory: (value ==
                                                      0) // 아무것도 터치 안했으면
                                                  ? NoSplash
                                                      .splashFactory //스플레시 효과 비활성화
                                                  : InkSplash
                                                      .splashFactory, //스플레시 효과 활성화
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              minimumSize: const Size(
                                                  double.infinity, 40),
                                              backgroundColor: value != 0
                                                  ? const Color(0xffF15A2B)
                                                  : Colors.grey[300],
                                            ),
                                            child: Text(
                                              "가게 신고",
                                              style: TextStyle(
                                                  color: (value > 0)
                                                      ? Colors.white
                                                      : Colors.grey[600]),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  },
                  child: const Text("신고",
                      style: TextStyle(fontSize: 20, color: Colors.orange)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

// 별점을 표시하는 위젯
class RatingWidget extends StatelessWidget {
  final int rating; // 평점 값
  const RatingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ..._buildStarIcons(), // 별 아이콘을 생성하여 추가
      ],
    );
  }

  // 별 아이콘 리스트를 생성하는 함수
  List<Widget> _buildStarIcons() {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(const Icon(Icons.star, color: Colors.orange)); //start full
      } else if (i - rating <= 0.5) {
        stars
            .add(const Icon(Icons.star_half, color: Colors.orange)); //star half
      } else {
        stars.add(
            const Icon(Icons.star_border, color: Colors.orange)); //start blank
      }
    }
    return stars;
  }
}

Widget _radioBtn(String text, int index, StateSetter setStater) {
  return ElevatedButton(
    onPressed: () {
      setStater(() {
        value = index;
        logger.d('선택한 index : $index');
      });
    },
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      minimumSize: const Size(double.infinity, 40),
      backgroundColor:
          (value == index) ? const Color(0xffF15A2B) : Colors.grey[300],
    ),
    child: Text(
      text,
      style:
          TextStyle(color: (value == index) ? Colors.white : Colors.grey[600]),
    ),
  );
}

// 개별 리뷰를 표시하는 함수
Widget _showReview2(BuildContext context, int rating, int index) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/rakoon.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('연수민'),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red[100],
                        ),
                        child: Text(
                          "난 한 가게만 패",
                          style: TextStyle(
                              fontSize: 10, color: Colors.redAccent[400]),
                        ),
                      ),
                    ],
                  ),
                  RatingWidget(rating: rating), // 별점 위젯 추가
                ],
              ),
            ],
          ),
          const Text(''),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                Image(image: AssetImage('assets/images/rakoon.png')),
                Image(image: AssetImage('assets/images/rakoon.png')),
                Image(image: AssetImage('assets/images/rakoon.png')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text("2024.04.02"),
              const Spacer(),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "리뷰 신고하기",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          setState(() => value = 0);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(CupertinoIcons.xmark))
                                  ],
                                ),
                                //버튼 모음
                                Container(
                                  height: 350,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _radioBtn('홍보성 리뷰에요', 1, setState),
                                      _radioBtn('도배 글이에요', 2, setState),
                                      _radioBtn('부적절한 내용이에요(욕설, 선정적 내용 등)', 3,
                                          setState),
                                      _radioBtn('가게에 무관한 리뷰에요', 4, setState),
                                      _radioBtn('기타', 5, setState),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            (value == 0)
                                                ? null
                                                : logger.d('버튼 활성화');
                                            //dio.post()구현
                                          },
                                          style: ElevatedButton.styleFrom(
                                            splashFactory: (value ==
                                                    0) // 아무것도 터치 안했으면
                                                ? NoSplash
                                                    .splashFactory //스플레시 효과 비활성화
                                                : InkSplash
                                                    .splashFactory, //스플레시 효과 활성화
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            minimumSize:
                                                const Size(double.infinity, 40),
                                            backgroundColor: value != 0
                                                ? const Color(0xffF15A2B)
                                                : Colors.grey[300],
                                          ),
                                          child: Text(
                                            "가게 신고",
                                            style: TextStyle(
                                                color: (value > 0)
                                                    ? Colors.white
                                                    : Colors.grey[600]),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
                child: const Text("신고",
                    style: TextStyle(fontSize: 20, color: Colors.orange)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    ),
  );
}

class ShowAllReviews extends StatelessWidget {
  const ShowAllReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 전체'),
      ),
      body: ListView(
        children: [
          _showReview2(context, 4, 1),
        ],
      ),
    );
  }
}
