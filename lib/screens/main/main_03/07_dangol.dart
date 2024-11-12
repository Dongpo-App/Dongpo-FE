import 'package:dongpo_test/widgets/map_manager.dart';
import 'package:flutter/material.dart';

class DanGolGuest extends StatelessWidget {
  DanGolGuest({super.key});
  final MapManager manager = MapManager();

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    //final screenWidth = MediaQuery.of(context).size.width;
    // 좌우 마진 제외
    //final contentsWidth = screenWidth - 48;

    bool mostVisitView = true;
    if (manager.selectedDetail != null &&
        manager.selectedDetail!.mostVisitMembers != null &&
        manager.selectedDetail!.mostVisitMembers!.isEmpty) {
      // `mostVisitMembers`가 비어 있는 경우
      mostVisitView = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          '이 가게 단골 손님',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        mostVisitView
            ? SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: manager.selectedDetail!.mostVisitMembers!.length,
                    itemBuilder: (context, index) {
                      var mostVisitMember =
                          manager.selectedDetail!.mostVisitMembers![index];
                      return Card(
                        elevation: 0,
                        color: const Color(0xff7f4f4f4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      (mostVisitMember.profilePic != null &&
                                              mostVisitMember
                                                  .profilePic!.isNotEmpty)
                                          ? NetworkImage(
                                                  mostVisitMember.profilePic!)
                                              as ImageProvider
                                          : const AssetImage(
                                              'assets/images/profile.jpg'),
                                ),
                                const SizedBox(
                                  // 테스트용
                                  width: 24,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 칭호
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5E0D9),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color:
                                              const Color(0xFFF5E0D9), // 테두리 색상
                                        ),
                                      ),
                                      child: Text(
                                        mostVisitMember.title!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFF15A2B),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4), // 간격 조정
                                    // 닉네임
                                    Text(
                                      mostVisitMember.nickname!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      );
                    }),
              )
            : const Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
      ]),
    );
  }
}

//  Color(0xffF15A2B), // 주황색
// Color(0xff767676), 회색
