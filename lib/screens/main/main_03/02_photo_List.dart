import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';

import '../../../models/store/store_detail.dart';

class MainPhoto extends StatefulWidget {
  final List<Review> reviewList;

  const MainPhoto({
    super.key,
    required this.reviewList
  });

  @override
  MainPhotoState createState() => MainPhotoState();
}

class MainPhotoState extends State<MainPhoto> {
  MapManager manager = MapManager();
  final List<Image> imageList = [];

  @override
  void initState() {
    super.initState();
    loadPhoto(widget.reviewList); // 페이지가 로드될 때 사진을 로드하는 메서드를 호출
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 120,
      color: Colors.white,
      child: imageList.isEmpty
          ? const Center(
              child: Text(
              '사진 리뷰가 아직 없는 가게예요',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF767676)),
            )) // 이미지가 없을 때 로딩 표시
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 200,
                  child: imageList[index], // 이미지 리스트에서 이미지를 가져옴
                );
              },
            ),
    );
  }

  void loadPhoto(List<Review> reviewList) {
    // storeData가 null이 아니고 reviews가 있는지 확인
    try {
      if (reviewList != null) {
        for (int i = 0; i < reviewList.length; i++) {
          // logger.d(
          //     '첫번째 for문 들어옴 리뷰 사진 갯수 : ${manager.selectedDetail!.reviews![i].reviewPics!.length}');
          for (int ii = 0;
              ii < reviewList[i].reviewPics!.length;
              ii++) {
            //   logger.d("두 번째 for문 들어옴 ");
            setState(() {
              imageList.add(Image.network(
                  '${reviewList[i].reviewPics?[ii]}'));
            });
          }
        }
      } else {
        logger.e("review 데이터가 없습니다.");
      }
    } on Exception catch (e) {
      logger.e("Error! 내용 = $e");
    }
  }
}
