import 'dart:convert';
import 'package:dongpo_test/models/response/api_response.dart';
import 'package:dongpo_test/models/store/store_detail.dart';
import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dongpo_test/screens/login/login.dart';
import 'package:dongpo_test/screens/login/login_view_model.dart';
import 'package:dongpo_test/service/exception/exception.dart';
import 'package:dongpo_test/service/store_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dongpo_test/main.dart';
import 'package:intl/intl.dart';

int value = 0;

class ShowReview extends StatefulWidget {
  final int idx;
  const ShowReview({super.key, required this.idx});

  @override
  State<ShowReview> createState() => _ShowReviewState();
}

//사진 관련
class _ShowReviewState extends State<ShowReview> {
  MapManager manager = MapManager();
  StoreApiService storeService = StoreApiService.instance;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  List<Review> reviewList = [];
  String etcText = ''; //리뷰 신고

  @override
  void initState() {
    reviewList = manager.selectedDetail?.reviews ?? []; // null일 경우 빈 리스트로 대체
    super.initState();
  }

//여기서 부터 화면
  @override
  Widget build(BuildContext context) {
    int storeId = widget.idx;
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 좌우 마진 제외
    final contentsWidth = screenWidth - 48;
    // 리뷰 텍스트 확인용
    bool reviewTextChecked = false;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "리뷰 ${reviewList.length}개",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height: 44,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      //상단 1
                                      Row(
                                        children: [
                                          const Text(
                                            "방문 후기를 알려주세요",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              _showConfirmationDialog(context);
                                            },
                                            icon: const Icon(CupertinoIcons.xmark,
                                                color: Color(0xFF767676), size: 24),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 24,
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
                                            itemSize: 56,
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
                                        height: 24,
                                      ),
                                      //사진 첨부 텍스트 //상단 3
                                      const Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "사진 첨부",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            " 최대 3개까지 선택 가능해요",
                                            style: TextStyle(
                                              color: Color(0xFF767676),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // 사진 첨부 버튼과 이미지 미리보기 //상단 4
                                      Row(
                                        children: List.generate(3, (index) =>
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: index < _pickedImgs.length
                                                      ? Colors.transparent
                                                      : Colors.white70,
                                                  width: 1),
                                              image: index < _pickedImgs.length
                                                  ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                  File(_pickedImgs[index]
                                                      .path),
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
                                        height: 16,
                                      ),
                                      //텍스트 필드 (200글자 이내로 작성해주세요!) //상단 5
                                      SizedBox(
                                        height: 200,
                                        child: TextField(
                                          controller: _reviewController,
                                          onChanged: (text) {
                                            if (text.isNotEmpty) {
                                              reviewTextChecked = true;
                                            } else {
                                              reviewTextChecked = false;
                                            }
                                          },
                                          maxLength: 200,
                                          maxLines: 4,
                                          decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF767676),
                                                )
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(12)),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF767676),
                                                )
                                            ),
                                            hintText: '200 글자 이내로 적어주세요!',
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF767676),
                                            ),
                                          ),
                                        ),
                                      ),

                                      //바닥에 리뷰 등록 버튼 (form전송)
                                      SizedBox(
                                        height: 44,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (!reviewTextChecked) {
                                              return;
                                            }
                                            try {
                                              ApiResponse apiResponse = await storeService.addReview(
                                                id: storeId,
                                                reviewText: _reviewController.text,
                                                images: _pickedImgs,
                                                rating: _rating,
                                              );
                                              logger.d("review post api statusCode : ${apiResponse.statusCode}");
                                              if (apiResponse.statusCode == 200) {
                                                await Future.delayed(const Duration(milliseconds: 1200));
                                                Fluttertoast.showToast(
                                                  msg: "리뷰 등록 완료",
                                                  timeInSecForIosWeb: 2,
                                                );
                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                }
                                              }
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
                                            elevation: 0,
                                            minimumSize:
                                            const Size(double.infinity, 50),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                            backgroundColor: (reviewTextChecked)
                                                ? const Color(0xffF15A2B)
                                                : const Color(0xFFF4F4F4),
                                          ),
                                          child: Text(
                                            "리뷰 등록",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: (reviewTextChecked)
                                                ? Colors.white
                                                : const Color(0xFF767676),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  backgroundColor: const Color(0xffF15A2B),
                ),
                child: const Text(
                  '리뷰 등록',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(height: 96),
          //showReview 넣을 곳

          reviewList.isNotEmpty
            ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shrinkWrap: true, // 높이를 자동으로 조정
              physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
              itemCount: reviewList.length,
              itemBuilder: (context, index) {
                final review =
                    reviewList[index].reviewStar; // 항상 비어있지 않으므로 직접 접근
                logger.d('리뷰 리스트에 들어있는 값 체크 : $review');
                return _showReview(context, index); // 각 리뷰 위젯 생성
              },
            )
            : Container(
                child: const Center(
                  child: Text(
                    '리뷰가 아직 없는 가게예요',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF767676)),
                  )
                ),
              ), // 리뷰가 없을 경우 빈 컨테이너 또는 메시지를 반환

          const SizedBox(height: 24,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowAllReviews(idx: storeId),
                  )
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                minimumSize: const Size(double.infinity, 44),
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

  void sucessAddReviewAlert(BuildContext context) {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "리뷰 등록",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "리뷰 등록이 완료되었습니다.",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Center(child: okButton),
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// 개별 리뷰를 표시하는 함수
  Widget _showReview(BuildContext context, int index) {
    String reviewDate = DateFormat('yyyy-MM-dd').format(reviewList[index].registerDate);
    bool reportTextChecked = false;

    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: (reviewList[index].memberProfilePic != null &&
                    reviewList[index].memberProfilePic!.isNotEmpty)
                    ? NetworkImage('${reviewList[index].memberProfilePic}')
                as ImageProvider
                    : const AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${reviewList[index].memberNickname}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF5E0D9),
                          border: Border.all(
                            color:
                            const Color(0xFFF5E0D9), // 테두리 색상
                          ),
                        ),
                        child: Text(
                          "${reviewList[index].memberMainTitle}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF15A2B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  RatingBarIndicator(
                    rating: reviewList[index].reviewStar!,
                    itemCount: 5,
                    itemSize: 16.0,
                    unratedColor: const Color(0xFF767676),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color(0xFFF15A2B),
                    ),
                  ),
                  // RatingWidget(
                  //     rating: reviewList[index].reviewStar ?? 0), // 별점 위젯 추가
                ],
              ),
            ],
          ),
          SizedBox(height: 24,),
          Text(
            '${reviewList[index].text}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          reviewList[index].reviewPics?.isEmpty ?? true
            ? const SizedBox(height: 0,)
            : SizedBox(
                height: 64,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: reviewList[index].reviewPics!.map((url) => GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.black,
                            child: Container(
                              width: MediaQuery.of(context).size.width, // 화면의 너비
                              height: MediaQuery.of(context).size.height, // 화면의 높이
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain, // 이미지 비율 유지
                                  image: NetworkImage(url),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 64, // 이미지 너비
                      height: 64,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(url),
                        ),
                      ),
                    ),
                  )).toList(),
                )
              ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                reviewDate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF767676),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  TextEditingController textController2 = TextEditingController(); // TextEditingController 정의

                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true, // 모달 시트의 크기를 조절 가능하게 설정
                    builder: (context) {
                      return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 24,
                            bottom: MediaQuery.of(context)
                                .viewInsets
                                .bottom, // 키보드가 올라오면 그만큼 패딩 추가
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "리뷰 신고하기",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            setState(() => value = 0);
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            CupertinoIcons.xmark,
                                            size: 24,
                                            color: Color(0xFF767676),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 40,),
                                    Column(
                                      children: [
                                        _radioBtn('홍보성 리뷰에요', 1, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('도배 글이에요', 2, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('부적절한 내용이에요(욕설, 선정적 내용 등)', 3,
                                            setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('가게에 무관한 리뷰에요', 4, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('기타', 5, setState),
                                        if (value == 5)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: TextField(
                                              controller: textController2,
                                              onChanged: (text) {
                                                if (text.isNotEmpty) {
                                                  reportTextChecked = true;
                                                } else {
                                                  reportTextChecked = false;
                                                }
                                              },
                                              maxLength: 100,
                                              decoration: const InputDecoration(
                                                hintText: '기타 사항을 입력해주세요',
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF767676),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Color(0xFF767676),
                                                    )
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(12)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Color(0xFF767676),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 32),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (value == 5 && !reportTextChecked) {
                                              return;
                                            }
                                            if (value != 0) {
                                              etcText = (value == 5)
                                                ? textController2.text
                                                : "";
                                              reviewStoreReport(index, etcText);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            splashFactory: value == 0
                                                ? NoSplash.splashFactory
                                                : InkSplash.splashFactory,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            minimumSize:
                                            const Size(double.infinity, 44),
                                            backgroundColor: ((value > 0 && value < 5) || (value == 5 && reportTextChecked))
                                                ? const Color(0xffF15A2B)
                                                : const Color(0xFFF4F4F4),
                                          ),
                                          child: Text(
                                            "리뷰 신고",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: ((value > 0 && value < 5) || (value == 5 && reportTextChecked))
                                                ? Colors.white
                                                : const Color(0xFF767676),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
                child: const Text(
                  "신고",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF767676),
                    decoration: TextDecoration.underline, // 밑줄 추가
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(
            color: Color(0xFFD0D0D0),
          ),
        ],
      ),
    );
  }

  // 리뷰 점포 신고
  void reviewStoreReport(int idx, String etcText) async {
    String sendData = setReportData(value);
    logger.d("sendData : $sendData");
    final url = Uri.parse('$serverUrl/api/report/review/${reviewList[idx].id}');

    final accessToken = await storage.read(key: 'accessToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final includeTextData = {
      "text": etcText, // reason이 ETC일 경우 포함
      "reason": sendData,
    };

    final exceptTextData = {
      "reson": sendData,
    };
    logger.d("_send : sendData");
    Map<String, String> data;

    if (value == 5) {
      data = includeTextData;
    } else {
      data = exceptTextData;
    }

    logger.d('send Body check value : $value data : $data');

    final body = jsonEncode(data);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      final responsebody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        logger.d('신고 완료!! 신고 내용 : $sendData & ETC : $etcText');
        logger.d('신고한 리뷰 ID = :${reviewList[idx].id}');
        showSuccessDialog();
      } else {
        logger.e(
            'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : $responsebody');
      }
    } catch (e) {
      // TODO
      logger.d("HTTP ERROR in storeReposrt method!! Error 내용 : $e");
    }
  }

  String setReportData(int idx) {
    switch (idx) {
      case 1:
        return "PROMOTIONAL_REVIEW";
      case 2:
        return "SPAM";
      case 3:
        return " INAPPOSITE_INFO";
      case 4:
        return "IRRELEVANT_CONTENT";
      case 5:
        return "ETC";
      default:
        "";
    }

    return "";
  }

  void showSuccessDialog() {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "신고 성공!",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "성공적으로 신고가 접수되었어요!",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Center(child: okButton),
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

// 별점을 표시하는 위젯
// class RatingWidget extends StatelessWidget {
//   final int rating; // 평점 값
//   const RatingWidget({super.key, required this.rating});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         ..._buildStarIcons(), // 별 아이콘을 생성하여 추가
//       ],
//     );
//   }
//
//   // 별 아이콘 리스트를 생성하는 함수
//   List<Widget> _buildStarIcons() {
//     List<Widget> stars = [];
//     for (int i = 1; i <= 5; i++) {
//       if (i <= rating) {
//         stars.add(const Icon(Icons.star, color: Colors.orange)); //start full
//       } else if (i - rating <= 0.5) {
//         stars
//             .add(const Icon(Icons.star_half, color: Colors.orange)); //star half
//       } else {
//         stars.add(
//             const Icon(Icons.star_border, color: Colors.orange)); //start blank
//       }
//     }
//     return stars;
//   }
// }

Widget _radioBtn(String text, int index, StateSetter setStater) {
  return SizedBox(
    height: 44,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        setStater(() {
          value = index;
          logger.d('선택한 index : $index');
        });
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 0,
        minimumSize: const Size(double.infinity, 44),
        backgroundColor: (value == index) ? const Color(0xffF15A2B) : const Color(0xFFF4F4F4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: (value == index) ? Colors.white : const Color(0xFF767676)),
      ),
    ),
  );
}

class ShowAllReviews extends StatefulWidget {
  final int idx;
  const ShowAllReviews({super.key, required this.idx});

  @override
  State<ShowAllReviews> createState() => _ShowAllReviewsState();
}

class _ShowAllReviewsState extends State<ShowAllReviews> {
  StoreApiService storeService = StoreApiService.instance;
  MapManager manager = MapManager();
  List<Review> reviewList = [];
  @override
  void initState() {
    reviewList = manager.selectedDetail?.reviews ?? []; // null일 경우 빈 리스트로 대체
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "전체 리뷰",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 24,
              color: Color(0xFF767676),
            )
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true, // 높이를 자동으로 조정
        physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
        itemCount: reviewList.length,
        itemBuilder: (context, index) {
          final review = reviewList[index].reviewStar; // 항상 비어있지 않으므로 직접 접근
          logger.d('리뷰 리스트에 들어있는 값 체크 : $reviewList');

          return _showReview(context, index); // 각 리뷰 위젯 생성
        },
      )
    );
  }

// 개별 리뷰를 표시하는 함수
  Widget _showReview(BuildContext context, int index) {
    String reviewDate = DateFormat('yyyy-MM-dd').format(reviewList[index].registerDate);
    bool reportTextChecked = false;

    return Container(
      margin: const EdgeInsets.only(top: 24, right: 24, left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: (reviewList[index].memberProfilePic != null &&
                    reviewList[index].memberProfilePic!.isNotEmpty)
                    ? NetworkImage('${reviewList[index].memberProfilePic}')
                as ImageProvider
                    : const AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${reviewList[index].memberNickname}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF5E0D9),
                          border: Border.all(
                            color:
                            const Color(0xFFF5E0D9), // 테두리 색상
                          ),
                        ),
                        child: Text(
                          "${reviewList[index].memberMainTitle}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF15A2B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  RatingBarIndicator(
                    rating: reviewList[index].reviewStar!,
                    itemCount: 5,
                    itemSize: 16.0,
                    unratedColor: const Color(0xFF767676),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color(0xFFF15A2B),
                    ),
                  ),
                  // RatingWidget(
                  //     rating: reviewList[index].reviewStar ?? 0), // 별점 위젯 추가
                ],
              ),
            ],
          ),
          SizedBox(height: 24,),
          Text(
            '${reviewList[index].text}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          reviewList[index].reviewPics?.isEmpty ?? true
            ? const SizedBox(height: 0,)
            : SizedBox(
                height: 64,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: reviewList[index].reviewPics!.map((url) => GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.black,
                            child: Container(
                              width: MediaQuery.of(context).size.width, // 화면의 너비
                              height: MediaQuery.of(context).size.height, // 화면의 높이
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain, // 이미지 비율 유지
                                  image: NetworkImage(url),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 64, // 이미지 너비
                      height: 64,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(url),
                        ),
                      ),
                    ),
                  )).toList(),
                )
              ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                reviewDate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF767676),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  TextEditingController textController = TextEditingController();

                  String etcText2 = ''; // 리뷰 전체 신고

                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true, // 모달 시트의 크기를 조절 가능하게 설정
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 24,
                            bottom: MediaQuery.of(context)
                                .viewInsets
                                .bottom, // 키보드가 올라오면 그만큼 패딩 추가
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "리뷰 신고하기",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            setState(() => value = 0);
                                            Navigator.pop(context);
                                          },
                                          icon:
                                          const Icon(
                                            CupertinoIcons.xmark,
                                            size: 24,
                                            color: Color(0xFF767676),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 40,),
                                    Column(
                                      children: [
                                        _radioBtn('홍보성 리뷰에요', 1, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('도배 글이에요', 2, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('부적절한 내용이에요(욕설, 선정적 내용 등)', 3, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('가게에 무관한 리뷰에요', 4, setState),
                                        const SizedBox(height: 16),
                                        _radioBtn('기타', 5, setState),
                                        if (value == 5)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: TextField(
                                              controller: textController,
                                              onChanged: (text) {
                                                if (text.isNotEmpty) {
                                                  reportTextChecked = true;
                                                } else {
                                                  reportTextChecked = false;
                                                }
                                              },
                                              maxLength: 100,
                                              decoration:
                                              const InputDecoration(
                                                hintText: '기타 사항을 입력해주세요',
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF767676),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Color(0xFF767676),
                                                    )
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(12)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Color(0xFF767676),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 32),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (value == 5 && !reportTextChecked) {
                                              return;
                                            }
                                            if (value != 0) {
                                              etcText2 = (value == 5)
                                                ? textController.text
                                                : "";
                                              reviewStoreReport2(index, etcText2);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            splashFactory: value == 0
                                                ? NoSplash.splashFactory
                                                : InkSplash.splashFactory,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            minimumSize: const Size(
                                                double.infinity, 44),
                                            backgroundColor: ((value > 0 && value < 5) || (value == 5 && reportTextChecked))
                                                ? const Color(0xffF15A2B)
                                                : const Color(0xFFF4F4F4),
                                          ),
                                          child: Text(
                                            "리뷰 신고",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: ((value > 0 && value < 5) || (value == 5 && reportTextChecked))
                                                ? Colors.white
                                                : const Color(0xFF767676),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
                child: const Text(
                  "신고",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF767676),
                    decoration: TextDecoration.underline, // 밑줄 추가
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(
            color: Color(0xFFD0D0D0),
          ),
        ],
      ),

    );
  }

  // 리뷰 점포 신고
  void reviewStoreReport2(int idx, String etcText) async {
    String sendData = setReportData(value);
    logger.d("sendData : $sendData");
    final url = Uri.parse('$serverUrl/api/report/review/${reviewList[idx].id}');

    final accessToken = await storage.read(key: 'accessToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final includeTextData = {
      "text": etcText, // reason이 ETC일 경우 포함
      "reason": sendData,
    };

    final exceptTextData = {
      "reson": sendData,
    };
    logger.d("_send : sendData");
    Map<String, String> data;

    if (value == 5) {
      data = includeTextData;
    } else {
      data = exceptTextData;
    }

    logger.d('send Body check value : $value data : $data');

    final body = jsonEncode(data);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      final responsebody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        logger.d('신고 완료!! 신고 내용 : $sendData & ETC : $etcText');
        logger.d('신고한 리뷰 ID = :${reviewList[idx].id}');
        showSuccessDialog();
      } else {
        logger.e(
            'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : $responsebody');
      }
    } catch (e) {
      // TODO
      logger.d("HTTP ERROR in storeReposrt method!! Error 내용 : $e");
    }
  }

  String setReportData(int idx) {
    switch (idx) {
      case 1:
        return "PROMOTIONAL_REVIEW";
      case 2:
        return "SPAM";
      case 3:
        return " INAPPOSITE_INFO";
      case 4:
        return "IRRELEVANT_CONTENT";
      case 5:
        return "ETC";
      default:
        "";
    }

    return "";
  }

  void showSuccessDialog() {
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: const Color(0xffF15A2B)),
      child: const Text(
        "확인",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "신고 성공!",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "성공적으로 신고가 접수되었어요!",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Center(child: okButton),
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}