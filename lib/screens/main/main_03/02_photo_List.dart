import 'package:dongpo_test/models/gaGeSangSe.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';

class MainPhoto extends StatefulWidget {
  const MainPhoto({super.key});

  @override
  _MainPhotoState createState() => _MainPhotoState();
}

class _MainPhotoState extends State<MainPhoto> {
  final List<Image> imageList = [];

  @override
  void initState() {
    super.initState();
    loadPhoto(); // 페이지가 로드될 때 사진을 로드하는 메서드를 호출
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.white,
      child: imageList.isEmpty
          ? const Center(child: Text('등록된 이미지가 아직 없습니다!')) // 이미지가 없을 때 로딩 표시
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 200,
                  margin: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                  child: imageList[index], // 이미지 리스트에서 이미지를 가져옴
                );
              },
            ),
    );
  }

  void loadPhoto() {
    // storeData가 null이 아니고 reviews가 있는지 확인
    try {
      if (storeData != null && storeData!.reviews != null) {
        for (int i = 0; i < storeData!.reviews!.length; i++) {
          // logger.d(
          //     '첫번째 for문 들어옴 리뷰 사진 갯수 : ${storeData!.reviews![i].reviewPics!.length}');
          for (int ii = 0;
              ii < storeData!.reviews![i].reviewPics!.length;
              ii++) {
            //   logger.d("두 번째 for문 들어옴 ");
            setState(() {
              imageList.add(
                  Image.network('${storeData?.reviews?[i].reviewPics?[ii]}'));
            });
          }
        }
      } else {
        logger.e("storeData 혹은 review 데이터가 없습니다.");
      }
    } on Exception catch (e) {
      logger.e("Error! 내용 = $e");
    }
  }
}
