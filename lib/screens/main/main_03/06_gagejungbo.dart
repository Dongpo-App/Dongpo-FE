import 'package:dongpo_test/screens/main/main_03/06_gagaeUpdate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dongpo_test/widgets/buttonForm.dart';

class GageJungbo extends StatelessWidget {
  const GageJungbo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          const Row(
            children: [
              Text('가게 정보'),
              Text('A 님이 등록하셨어요.'),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 160,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      '오픈 요일 ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Spacer(),
                    Text('data'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '오픈 시간 ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Spacer(),
                    Text('data'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '결제 방식 ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Spacer(),
                    Text('data')
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '화장실 ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Spacer(),
                    Text("data")
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
              onPressed: () {
                //가게 정보 수정하기
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const GagaeUpdate();
                }));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                backgroundColor: const Color(0xffF15A2B),
              ),
              child: const Text(
                "가게정보 수정하기",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
