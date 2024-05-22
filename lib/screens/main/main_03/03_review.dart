import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowReview extends StatelessWidget {
  const ShowReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("리뷰 31개",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () {
              showBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      height: 400,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("방문 후기를 알려주세요"),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.cancel_outlined))
                            ],
                          )
                        ],
                      ),
                    );
                  });
            },
            child: Text("리뷰쓰러가기")),
        SizedBox(
          height: 15,
        ),
        Container(
          width: 400,
          color: Colors.grey[350],
          child: Text("별"),
        ),
        SizedBox(
          height: 40,
        ),
        _showReview(context),
        _showReview(context),
        _showReview(context),
      ],
    );
  }

  Widget _showReview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이 가게 단골 손님',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/rakoon.png'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('연수민'),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "난 한가게만 패",
                        ),
                      ],
                    ),
                    Text("별")
                  ],
                ),
              ],
            ),
            Text(
                "aaaaajhisadbiubfgiusadhfuhasudhfuiabsdifubdfuijibasidbijasbdiabsdiijbaisbdjiasbd"),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("2024.04.02"),
                Spacer(),
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            child: Center(child: Text('신고하기')),
                          );
                        },
                      );
                    },
                    child: Text(
                      "신고",
                      style: TextStyle(fontSize: 20, color: Colors.orange),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
