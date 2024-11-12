import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTitle extends StatefulWidget {
  final int idx;
  const MainTitle({super.key, required this.idx});

  @override
  State<MainTitle> createState() => _MainTitleState();
}

class _MainTitleState extends State<MainTitle> {
  MapManager manager = MapManager();
  bool setOpenPossbility = false;
  String betweenDistance = "";

  @override
  void initState() {
    _initializeAsyncData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                manager.selectedDetail?.name ?? '이름이 없습니다',
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
                    betweenDistance,
                    style: const TextStyle(
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
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )
        ],
      ),
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
    setState(() {});
  }
}
