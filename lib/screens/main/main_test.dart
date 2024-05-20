// import 'package:flutter/material.dart';
// import 'package:dongpo_test/widgets/main/map.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MapScreen(),
//     );
//   }
// }

// class MapScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           NaverMapApp(),
//           Positioned(
//             top: 40.0,
//             left: 16.0,
//             right: 16.0,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 5.0,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: <Widget>[
//                   Icon(Icons.search),
//                   SizedBox(width: 8.0),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: '서울특별시 고척동 경인로 445',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 16.0,
//             left: 16.0,
//             right: 16.0,
//             child: Container(
//               height: 60.0,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 5.0,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   IconButton(
//                     icon: Icon(Icons.home),
//                     onPressed: () {},
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () {},
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.chat),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 90.0,
//             right: 16.0,
//             child: FloatingActionButton(
//               onPressed: () {
//                 // 내 위치 버튼 클릭 시 실행할 코드
//               },
//               child: Icon(Icons.my_location),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:dongpo_test/api_key.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SearchPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('위치 검색'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: AddressSearchBar(),
//           ),
//           Expanded(child: AddressSuggestionsList()),
//         ],
//       ),
//     );
//   }
// }

// class AddressSearchBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: '주소 검색',
//         border: OutlineInputBorder(),
//         suffixIcon: Icon(Icons.search),
//       ),
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           context.read<AddressSearchProvider>().fetchSuggestions(value);
//         } else {
//           context.read<AddressSearchProvider>().clearSuggestions();
//         }
//       },
//     );
//   }
// }

// class AddressSuggestionsList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AddressSearchProvider>(
//       builder: (context, provider, child) {
//         if (provider.suggestions.isEmpty) {
//           return Center(child: Text('추천 주소가 없습니다.'));
//         } else {
//           return ListView.builder(
//             itemCount: provider.suggestions.length,
//             itemBuilder: (context, index) {
//               final suggestion = provider.suggestions[index];
//               return ListTile(
//                 title: Text(suggestion['description']),
//                 onTap: () {
//                   provider.fetchCoordinates(suggestion['place_id']);
//                 },
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

// class AddressSearchProvider with ChangeNotifier {
//   final String apiKey = gMapApiKey;
//   List<Map<String, dynamic>> suggestions = [];

//   void fetchSuggestions(String input) async {
//     final url =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=ko&components=country:kr';
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       // 'predictions'가 List<dynamic>로 반환되므로, 이를 List<Map<String, dynamic>>로 변환합니다.
//       final List<dynamic> predictions = data['predictions'];
//       suggestions = predictions.cast<Map<String, dynamic>>();
//       notifyListeners();
//     }
//   }

//   void clearSuggestions() {
//     suggestions = [];
//     notifyListeners();
//   }

//   void fetchCoordinates(String placeId) async {
//     final url =
//         'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final location = data['result']['geometry']['location'];
//       final lat = location['lat'];
//       final lng = location['lng'];
//       print('위도: $lat, 경도: $lng');
//       // 필요한 동작 수행 (예: 위도와 경도를 사용하여 지도 업데이트 등)
//     }
//   }
// }
