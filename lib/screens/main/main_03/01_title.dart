import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MainTitle extends StatefulWidget {
  final int idx;
  const MainTitle({super.key, required this.idx});

  @override
  State<MainTitle> createState() => _MainTitleState();
}

class _MainTitleState extends State<MainTitle> {
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              storeData?.name ?? '이름이 없습니다',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Column(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                        size: 24,
                        CupertinoIcons.arrow_up_right_diamond_fill,
                        color: Color(0xffF15A2B))),
                Text(
                  "$betweenDistance M",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 16,
              color: Color(0xffF15A2B),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              SetOpenPossbility ? "영업 가능성이 높아요!" : "영업 가능성이 있어요!",
              style: TextStyle(
                color: Color(0xFF767676),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        )
      ],
    );
  }

  //사용자와 점포간의 거리계산
  void _checkDistance() async {
    Position myPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //int로 형변환
    int checkMeter = Geolocator.distanceBetween(
      myPosition.latitude,
      myPosition.longitude,
      storeData!.latitude,
      storeData!.longitude,
    ).floor();
    betweenDistance = checkMeter;
    logger.d('나와 점포 거리 차이는 = $checkMeter M');
  }

  bool getOpenPossibility() {
    if (storeData?.openPossibility == "HIGH") {
      return true;
    } else {
      return false;
    }
  }
}
