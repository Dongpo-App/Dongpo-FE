import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';
import 'package:geolocator/geolocator.dart';

class StoreSummaryTitle extends StatefulWidget {
  final int idx;
  const StoreSummaryTitle({super.key, required this.idx});

  @override
  State<StoreSummaryTitle> createState() => _StoreSummaryTitleState();
}

class _StoreSummaryTitleState extends State<StoreSummaryTitle> {
  MapManager manager = MapManager();
  bool setOpenPossbility = false;
  int betweenDistance = 0;

  @override
  void initState() {
    super.initState();
    setOpenPossbility = getOpenPossibility();
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
              manager.selectedSummary!.name,
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
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xffF15A2B),
            ),
            Text(
              setOpenPossbility ? "영업 가능성이 높아요!" : "영업 가능성이 있어요!",
            )
          ],
        )
      ],
    );
  }

  bool getOpenPossibility() {
    if (manager.selectedDetail?.openPossibility == "HIGH") {
      return true;
    } else {
      return false;
    }
  }

  //사용자와 점포간의 거리계산
  void _checkDistance() async {
    if (!mounted) return;

    Position myPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var checkMeter = Geolocator.distanceBetween(
      myPosition.latitude,
      myPosition.longitude,
      manager.selectedMarker!.latitude,
      manager.selectedMarker!.longitude,
    );

    betweenDistance = checkMeter.floor();
    setState(() {});

    logger.d('00_marker 나와 점포 거리 차이는 = $checkMeter M');
    logger.d('00_marker betwwenDistance = $betweenDistance');
  }
}

class MainPhoto2 extends StatefulWidget {
  const MainPhoto2({super.key});

  @override
  _MainPhotoState createState() => _MainPhotoState();
}

class _MainPhotoState extends State<MainPhoto2> {
  MapManager manager = MapManager();
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
    // manager.selectedDetail가 null이 아니고 reviews가 있는지 확인
    try {
      for (int i = 0; i < manager.selectedSummary!.reviewPics.length; i++) {
        imageList.add(Image.network(manager.selectedSummary!.reviewPics[i]));
      }
      setState(() {});
    } catch (e) {
      logger.e("Marker Error! 내용 = $e");
    }
  }
}
