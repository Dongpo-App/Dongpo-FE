
  // void storeReport(int storeId) async {
  //   final url = Uri.parse('$serverUrl/api/report/store/$storeId');

  //   final accessToken = await storage.read(key: 'accessToken');

  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $accessToken',
  //   };

  //   final response = await http.post(
  //     url,
  //     headers: headers,
  //   );

  //   if (response.statusCode == 200) {
  //   } else {
  //     logger.e(
  //         'HTTP ERROR !!! 상태코드 : ${response.statusCode}, 응답 본문 : ${response.body}');
  //     throw Exception('HTTP ERROR !!! ${response.body}');
  //   }
  // }

  // Future<void> sendData() async {
  //   final accessToken = await storage.read(key: 'accessToken');
  //   double value1 = dataForm.sendLatitude;
  //   double value2 = dataForm.sendLongitude;

  //   double truncatedValue1 = (value1 * 1000000).truncateToDouble() / 1000000;
  //   double truncatedValue2 = (value2 * 1000000).truncateToDouble() / 1000000;

  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   logger.d("현재 나의 위치 : ${position.latitude}");

  //   logger.d("$truncatedValue1 || $truncatedValue2");
  //   final data = {
  //     'name': _nameController.text,
  //     'address': dataForm.sendAddress,
  //     'latitude': truncatedValue1, //latitude
  //     'longitude': truncatedValue2, //longitude
  //     'openTime': openTime,
  //     'closeTime': closeTime,
  //     'isToiletValid': bathSelected == 1,
  //     'operatingDays': _getSelectedDays(),
  //     'payMethods': _getSelectedPaymentMethods(),
  //     "currentLatitude": position.latitude,
  //     "currentLongitude": position.longitude
  //   };

  //   final url = Uri.parse('$serverUrl/api/store');
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $accessToken',
  //   };
  //   final body = jsonEncode(data);

  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       logger.d('성공 보낸 데이터: $data');
  //       showAlertDialog(context);
  //     } else {
  //       logger.d('전송 실패 ${response.statusCode} 에러');
  //       //실패했을 떄
  //     }
  //   } catch (e) {
  //     logger.d('Error $e');
  //   }
  // }
