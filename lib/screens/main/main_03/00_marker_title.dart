import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/main.dart';

class StoreSummaryTitle extends StatefulWidget {
  final int idx;
  const StoreSummaryTitle({super.key, required this.idx});

  @override
  State<StoreSummaryTitle> createState() => _StoreSummaryTitleState();
}

class _StoreSummaryTitleState extends State<StoreSummaryTitle> {
  MapManager manager = MapManager();
  bool setOpenPossbility = false;
  String betweenDistance = "";

  @override
  void initState() {
    super.initState();
    _initializeAsyncData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                manager.selectedSummary!.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1, // 한 줄로 제한
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    CupertinoIcons.arrow_up_right_diamond_fill,
                    size: 24,
                    color: Color(0xffF15A2B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  betweenDistance,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: Color(0xffF15A2B),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    setOpenPossbility ? "영업 가능성이 높아요!" : "영업 가능성이 있어요!",
                    style: const TextStyle(
                      color: Color(0xFF767676),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
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

  Future<void> _initializeAsyncData() async {
    setOpenPossbility = getOpenPossibility();
    betweenDistance = await manager.calcDistanceStore();
    if (mounted) {
      setState(() {});
    }
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
