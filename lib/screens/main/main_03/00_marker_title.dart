import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';
import 'package:geolocator/geolocator.dart';

class MainTitle2 extends StatefulWidget {
  final int idx;
  const MainTitle2({super.key, required this.idx});

  @override
  State<MainTitle2> createState() => _MainTitle2State();
}

class _MainTitle2State extends State<MainTitle2> {
  late final SetOpenPossbility;
  int betweenDistance = 0;

  @override
  void initState() {
    super.initState();
    SetOpenPossbility = getOpenPossibility();
    _checkDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              markerInfo.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.arrow_up_right_diamond_fill,
                    color: Color(0xffF15A2B)))
          ],
        ),
        Text("$betweenDistance M"),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Color(0xffF15A2B),
            ),
            Text(
              SetOpenPossbility ? "영업 가능성이 높아요!" : "영업 가능성이 있어요!",
            )
          ],
        )
      ],
    );
  }

  bool getOpenPossibility() {
    if (storeData?.openPossibility == "HIGH") {
      return true;
    } else {
      return false;
    }
  }

  //사용자와 점포간의 거리계산
  void _checkDistance() async {
    Position myPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (widget.idx >= 0 && widget.idx < myDataList.length) {
      // myDataList[widget.idx]에 안전하게 접근
      var checkMeter = Geolocator.distanceBetween(
        myPosition.latitude,
        myPosition.longitude,
        myDataList[widget.idx].latitude,
        myDataList[widget.idx].longitude,
      );

      betweenDistance = checkMeter.floor();
      setState(() {});

      logger.d('00_marker 나와 점포 거리 차이는 = $checkMeter M');
      logger.d('00_marker betwwenDistance = $betweenDistance');
    } else {
      logger.e("유효하지 않은 인덱스: ${widget.idx}");
    }
  }
}

class MainPhoto2 extends StatefulWidget {
  const MainPhoto2({super.key});

  @override
  _MainPhotoState createState() => _MainPhotoState();
}

class _MainPhotoState extends State<MainPhoto2> {
  final List<Image> imageList = [];

  // 로딩
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true; // 초기화
    });
    loadPhoto(); // 페이지가 로드될 때 사진을 로드하는 메서드를 호출
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.white,
      child: imageList.isEmpty
          ? const Center(child: Text('등록된 이미지가 아직 없습니다!')) // 이미지가 없을 때 로딩 표시
          : isLoading
              ? const CircularProgressIndicator()
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
      for (int i = 0; i < markerInfo.reviewPics.length; i++) {
        imageList.add(Image.network(markerInfo.reviewPics[i]));
      }
      setState(() {});
    } catch (e) {
      logger.e("Marker Error! 내용 = $e");
    }
  }
}
