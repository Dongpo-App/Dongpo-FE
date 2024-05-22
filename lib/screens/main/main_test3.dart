import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고척 포장마차1'),
        actions: [
          IconButton(
            icon: Icon(Icons.report),
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
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          MainTitle(),
          BangMoon(),
          UserAction(),
          ShowReview(),
          SizedBox(height: 30),
          StoreInfo(),
          RegularCustomer(),
        ],
      ),
    );
  }
}

class MainTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('고척 포장마차1',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_pin),
              Text('영업 가능성 높아요'),
              Spacer(),
              Text('103m'),
            ],
          ),
        ],
      ),
    );
  }
}

class MainPhoto extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/rakoon.png'
        'assets/images/rakoon.png'
        'assets/images/rakoon.png'
        'assets/images/rakoon.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.amber,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(10),
            color: Colors.black,
            child: Image.asset(imagePaths[index]),
          );
        },
      ),
    );
  }
}

class BangMoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('방문 인증 하러 가기'),
        style: ElevatedButton.styleFrom(foregroundColor: Colors.orange),
      ),
    );
  }
}

class UserAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('리뷰 31개',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowReview extends StatelessWidget {
  final List<String> reviewImages = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(reviewImages.length, (index) {
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(reviewImages[index]),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('도도한 고양이',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('2024.04.02'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('국밥은 법령에 저촉되지 아니하는 범위안에서 의사와 내부 규율에 관한 규칙을 제정할 수 있다.'),
                SizedBox(height: 10),
                Row(
                  children: [
                    ...List.generate(reviewImages.length, (i) {
                      return Padding(
                        padding: EdgeInsets.all(4.0),
                        child:
                            Image.asset(reviewImages[i], width: 50, height: 50),
                      );
                    }),
                  ],
                ),
                Divider(),
              ],
            );
          }),
          ElevatedButton(
            onPressed: () {},
            child: Text('리뷰 더보기'),
          ),
        ],
      ),
    );
  }
}

class StoreInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('가게 정보',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('운영 요일: 월 화 수 목 금'),
                Text('오픈 시간: 오후 5시 ~ 오후 11시'),
                Text('결제 방식: 현금, 계좌이체, 카드'),
                Text('화장실: 있음'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RegularCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이 가게 단골 손님',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/customer.jpg'),
              ),
              SizedBox(width: 10),
              Text('도도한 고양이'),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainScreen(),
  ));
}
