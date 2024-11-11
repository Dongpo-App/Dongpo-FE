import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/store/store_detail.dart';
import '../../../widgets/map_manager.dart';

class GageJungbo extends StatefulWidget {
  const GageJungbo({super.key});

  @override
  GageJungboState createState() => GageJungboState();
}

class GageJungboState extends State<GageJungbo> {
  MapManager manager = MapManager();

  // 가게 정보 데이터
  List<String> operatingDays = [];
  String openTime = "";
  String closeTime = "";
  List<String> payMethods = [];
  bool isToiletValid = false;
  int memberId = 0;

  @override
  void initState() {
    getStoreInformation();
    openTime = formatTime(openTime);
    closeTime = formatTime(closeTime);

    super.initState();
  }

  void getStoreInformation() {
    operatingDays = manager.selectedDetail?.operatingDays ?? []; // null일 경우 빈 리스트로 대체
    openTime = manager.selectedDetail?.openTime ?? "";
    closeTime = manager.selectedDetail?.closeTime ?? "";
    payMethods = manager.selectedDetail?.payMethods ?? [];
    isToiletValid = manager.selectedDetail?.isToiletValid ?? false;
    memberId = manager.selectedDetail?.memberId ?? 0;
  }

  String formatTime(String time) {
    try {
      DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
      String formattedTime = DateFormat("a hh:mm").format(dateTime);
      formattedTime = formattedTime.replaceFirst('AM', '오전').replaceFirst('PM', '오후');
      formattedTime = '${formattedTime.replaceAll(':', '시')}분';
      return formattedTime;
    } catch (e) { return time; }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '가게 정보',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '도도한 고양이 님이 등록하셨어요.',
                style: TextStyle(
                  color: Color(0xFF767676),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text(
                      '영업 요일',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    for (int i = 0; i < 7; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          _getDayText(i),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: operatingDays.contains(_getDayCode(i)) ? Colors.black : const Color(0xFF969696),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24,),
                Row(
                  children: [
                    const Text(
                      '영업 시간',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "$openTime ~ $closeTime",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24,),
                Row(
                  children: [
                    const Text(
                      '결제 방식',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    for (String method in ['현금', '계좌이체', '카드'])
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0), // 텍스트 간 간격
                        child: Text(
                          method, // 각 결제 방법 텍스트
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: payMethods.contains(_getPayMethodCode(method)) ? Colors.black : const Color(0xFF969696), // payMethods에 해당 결제 방식이 있으면 빨간색
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24,),
                Row(
                  children: [
                    const Text(
                      '화장실',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '있음',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isToiletValid ? Colors.black : const Color(0xFF969696),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Text(
                      '없음',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isToiletValid ? const Color(0xFF969696) : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDayText(int index) {
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    return days[index];
  }

  String _getDayCode(int index) {
    const dayCodes = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return dayCodes[index];
  }

  String _getPayMethodCode(String method) {
    switch (method) {
      case '현금':
        return 'CASH';
      case '계좌이체':
        return 'TRANSFER';
      case '카드':
        return 'CARD';
      default:
        return '';
    }
  }
}
