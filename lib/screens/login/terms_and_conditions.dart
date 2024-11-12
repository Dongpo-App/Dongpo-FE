import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'web_view.dart';

Future<Map<String, bool>> showTermsAndConditionsBottomSheet(
    BuildContext context) async {
  final result = await showModalBottomSheet<Map<String, bool>>(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return const TermsAndConditionsAgreement();
    },
  );
  return result ??
      {
        'tosAgreeChecked': false,
        'marketingAgreeChecked': false,
      };
}

class TermsAndConditionsAgreement extends StatefulWidget {
  const TermsAndConditionsAgreement({super.key});

  @override
  State<TermsAndConditionsAgreement> createState() =>
      _TermsAndConditionsAgreementState();
}

class _TermsAndConditionsAgreementState
    extends State<TermsAndConditionsAgreement> {
  // 약관 동의
  bool allAgreeChecked = false;
  bool tosAgreeChecked = false;
  bool marketingAgreeChecked = false;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSheetHeight = screenHeight * 0.5;
    return SafeArea(
      child: Container(
        height: bottomSheetHeight,
        width: double.infinity,
        margin: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "약관 동의",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.xmark,
                    size: 24,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            // 전체 동의
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  setState(() {
                    allAgreeChecked = !allAgreeChecked;
                    tosAgreeChecked = allAgreeChecked;
                    marketingAgreeChecked = allAgreeChecked;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      allAgreeChecked
                          ? Icons.check_circle_sharp
                          : Icons.check_circle_outline_sharp,
                      color: allAgreeChecked
                          ? const Color(0xffF15A2B)
                          : const Color(0xFF767676),
                      size: 24, // 아이콘 크기
                    ),
                    const SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
                    const Text(
                      "전체 동의",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Color(0xFFD0D0D0),
            ),
            const SizedBox(height: 16),
            // 이용약관 동의
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  setState(() {
                    tosAgreeChecked = !tosAgreeChecked;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tosAgreeChecked
                          ? Icons.check_circle_sharp
                          : Icons.check_circle_outline_sharp,
                      color: tosAgreeChecked
                          ? const Color(0xffF15A2B)
                          : const Color(0xFF767676),
                      size: 24, // 아이콘 크기
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "[필수] 이용약관 동의",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        const url =
                            'https://wsw0922.notion.site/1377011bfe4b80c2971ad813a817c6cd?pvs=4';
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebView(url: url),
                            ));
                      },
                      icon: const Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Color(0xFF767676),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 마케팅 동의
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  setState(() {
                    marketingAgreeChecked = !marketingAgreeChecked;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      marketingAgreeChecked
                          ? Icons.check_circle_sharp
                          : Icons.check_circle_outline_sharp,
                      color: marketingAgreeChecked
                          ? const Color(0xffF15A2B)
                          : const Color(0xFF767676),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "[선택] 마케팅 활용·광고성 정보 수신 동의",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        const url =
                            'https://wsw0922.notion.site/1377011bfe4b804983fafe219fbdb1d1?pvs=4';
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebView(url: url),
                            ));
                      },
                      icon: const Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Color(0xFF767676),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 44,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0, // 그림자 제거
                    splashFactory: (tosAgreeChecked)
                        ? NoSplash.splashFactory
                        : InkSplash.splashFactory,
                    backgroundColor: (tosAgreeChecked)
                        ? const Color(0xffF15A2B)
                        : const Color(0xFFF4F4F4),
                    minimumSize: const Size(double.infinity, 44),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
                onPressed: () async {
                  logger.d(
                      "tosAgreeChecked : $tosAgreeChecked, marketingAgreeChecked : $marketingAgreeChecked");

                  if (!tosAgreeChecked) return;
                  Navigator.pop(context, {
                    'tosAgreeChecked': tosAgreeChecked,
                    'marketingAgreeChecked': marketingAgreeChecked,
                  });
                },
                child: Text(
                  '동의하고 동포 입장하기',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: (tosAgreeChecked)
                          ? Colors.white
                          : const Color(0xFF767676)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
