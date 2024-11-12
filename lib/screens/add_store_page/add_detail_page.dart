import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/models/request/add_store_request.dart';
import 'package:dongpo_test/service/store_service.dart';
import 'package:dongpo_test/widgets/dialog_method_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AddStorePageDetail extends StatefulWidget {
  final String address;
  final NLatLng position;
  const AddStorePageDetail(
      {super.key, required this.address, required this.position});

  @override
  State<AddStorePageDetail> createState() => _AddStorePageDetailState();
}

class _AddStorePageDetailState extends State<AddStorePageDetail>
    with DialogMethodMixin {
  StoreApiService storeService = StoreApiService.instance;

  // form
  final _formKey = GlobalKey<FormState>();
  // 폼
  bool _isFormValid = false; // 폼 유효성 상태

  // 입력 필드 관련
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _openTimeController = TextEditingController();
  final TextEditingController _closeTimeController = TextEditingController();
  // 요일 관련
  final List<bool> _selectedDays = List.generate(7, (index) => false);
  final List<String> _days = ["일", "월", "화", "수", "목", "금", "토"];
  // 영업 시간 관련
  late final DateTime _initialTime; // 초기화에 쓸 시간
  DateTime? _openTime; // 오픈 시간 저장
  DateTime? _closeTime; // 마감 시간
  // 시간 포맷 (오전/오후 표시)
  final DateFormat _timeFormatter =
      DateFormat('a h시 mm분', 'ko'); // 오전 9시 30분 형식
  final DateFormat _timeValueFormatter = DateFormat('HH:mm'); // 09:30 형식
  // 결제 방식 관련
  final List<bool> _selectedPaymentMethods = List.generate(3, (index) => false);
  final List<String> _payments = ["현금", "계좌이체", "카드"];
  // 화장실 관련
  late List<bool> _isToilets; // 선택됐는지 true false
  int _toiletIndex = 1; // 0 있음, 1 없음
  final List<String> _toilet = ["있음", "없음"]; // 요소

  // 가게 등록 상태 관리 변수
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.address;
    _initialTime = _getInitDate(minuteInterval: 5);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 전체 화면 너비
    final screenWidth = MediaQuery.of(context).size.width;
    // 좌우 마진 제외
    final contentsWidth = screenWidth - 48;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: addStoreAppBar(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    onChanged: _validateForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        // 가게 위치
                        const Row(
                          children: [
                            Text(
                              "가게 위치",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                color: Color(0xFFF15A2B),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // 가게 위치 검색바
                        SizedBox(
                          child: TextFormField(
                            controller: _addressController,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF767676),
                            ),
                            readOnly: true,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFF4F4F4)),
                                  borderRadius: BorderRadius.circular(12.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFF4F4F4)), // 비활성화 상태 테두리
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              fillColor: const Color(0xFFF4F4F4),
                              filled: true,
                              suffixIcon: const Icon(
                                  size: 16, CupertinoIcons.right_chevron),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              helperText: "", // 크기 유지를 위해
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // 가게 이름
                        const Row(
                          children: [
                            Text(
                              '가게 이름',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Color(0xFFF15A2B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // 가게이름 필드
                        SizedBox(
                          child: TextFormField(
                            controller: _nameController,
                            maxLength: 14,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF767676),
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "최대 14글자까지 입력 가능해요",
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF767676),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFF4F4F4)),
                                  borderRadius: BorderRadius.circular(12.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFF4F4F4)), // 비활성화 상태 테두리
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFF767676)),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color:
                                        Color(0xFFF15A2B)), // 포커스 + 에러 상태 테두리
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              fillColor: const Color(0xFFF4F4F4),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              helperText: "",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // 오픈 요일
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '오픈 요일',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '여러 개 선택 가능해요!',
                              style: TextStyle(
                                color: Color(0xFF767676),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // 요일 선택
                        Center(
                          child: ToggleButtons(
                            isSelected: _selectedDays,
                            onPressed: (index) {
                              _selectedDays[index] =
                                  !_selectedDays[index]; // 선택 상태 토글
                              _validateForm();
                            },
                            selectedColor: Colors.white,
                            renderBorder: false,
                            fillColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            children: _days
                                .asMap()
                                .entries
                                .map(
                                  (day) => toggleItemContainer(
                                      selected: _selectedDays,
                                      entry: day,
                                      isCircle: true,
                                      itemSize: contentsWidth * 0.118),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // 영업 시간
                        const Row(
                          children: [
                            Text(
                              '영업 시간',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Color(0xFFF15A2B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 오픈 시간 입력 필드
                            Expanded(
                              child: TextFormField(
                                controller: _openTimeController,
                                readOnly: true,
                                onTap: () => _showCupertinoTimePicker(context,
                                    isOpenTime: true),
                                decoration: InputDecoration(
                                  hintText: "오픈 시간",
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF767676),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFF4F4F4)),
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color(0xFFF4F4F4)), // 비활성화 상태 테두리
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF767676)),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(
                                            0xFFF15A2B)), // 포커스 + 에러 상태 테두리
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  fillColor: const Color(0xFFF4F4F4),
                                  filled: true,
                                  suffixIcon: const Icon(
                                      size: 24,
                                      color: Color(0xFF767676),
                                      Icons.access_time),
                                  helperText: "",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                "~",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF767676),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            // 마감 시간 입력 필드
                            Expanded(
                              child: TextFormField(
                                controller: _closeTimeController,
                                readOnly: true,
                                onTap: () => _showCupertinoTimePicker(context,
                                    isOpenTime: false),
                                decoration: InputDecoration(
                                  hintText: "마감 시간",
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF767676),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFF4F4F4)),
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color(0xFFF4F4F4)), // 비활성화 상태 테두리
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF767676)),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(
                                            0xFFF15A2B)), // 포커스 + 에러 상태 테두리
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  fillColor: const Color(0xFFF4F4F4),
                                  filled: true,
                                  suffixIcon: const Icon(
                                      size: 24,
                                      color: Color(0xFF767676),
                                      Icons.access_time),
                                  helperText: "",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // 결제 방식
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '결제 방식',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '여러 개 선택 가능해요!',
                              style: TextStyle(
                                color: Color(0xFF767676),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // 결제 입력
                        ToggleButtons(
                          isSelected: _selectedPaymentMethods,
                          onPressed: (index) {
                            _selectedPaymentMethods[index] =
                                !_selectedPaymentMethods[index]; // 선택 상태 토글
                            _validateForm();
                          },
                          selectedColor: Colors.white,
                          renderBorder: false,
                          fillColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          children: _payments
                              .asMap()
                              .entries
                              .map(
                                (payment) => toggleItemContainer(
                                  selected: _selectedPaymentMethods,
                                  entry: payment,
                                  isCircle: false,
                                  itemSize: contentsWidth * 0.28,
                                  margin: 8.0,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // 화장실 유무
                        const Row(
                          children: [
                            Text(
                              '화장실',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // 화장실 입력
                        Center(
                          child: ToggleButtons(
                              isSelected: _isToilets = List.generate(
                                  2,
                                  (index) =>
                                      index == _toiletIndex), // 현재 선택된 버튼
                              onPressed: (int index) {
                                setState(() {
                                  _toiletIndex = index; // 선택된 버튼의 인덱스 업데이트
                                });
                              },
                              selectedColor: Colors.white,
                              renderBorder: false,
                              fillColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              children: _toilet
                                  .asMap()
                                  .entries
                                  .map(
                                    (isthere) => toggleItemContainer(
                                      selected: _isToilets,
                                      entry: isthere,
                                      isCircle: false,
                                      itemSize: contentsWidth * 0.45,
                                      margin: 8.0,
                                    ),
                                  )
                                  .toList()),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        //End
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 가게 등록 버튼
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.085,
              child: ElevatedButton(
                onPressed: (_isFormValid && !isLoading)
                    ? () async {
                        await submitStoreAdd();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: (_isFormValid && !isLoading)
                      ? const Color(0xffF15A2B)
                      : const Color(0xFFF4F4F4),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "가게 등록",
                        style: TextStyle(
                          fontSize: 16,
                          color: (_isFormValid && !isLoading)
                              ? Colors.white
                              : const Color(0xFF767676),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 메서드
  Future<void> submitStoreAdd() async {
    if (isLoading) return;
    setState(() {
      isLoading = true; // 버튼 비활성화
    });

    if (_formKey.currentState!.validate()) {
      // 폼이 성공적으로 채워졌을 때
      final userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      AddStoreRequest storeInfo = AddStoreRequest(
        name: _nameController.text,
        address: _addressController.text,
        latitude: widget.position.latitude,
        longitude: widget.position.longitude,
        isToiletValid: _isToilets[0],
        // 첫 번째 요소가 있음으로 true면 있는 것
        openTime: _formatValueTime(_openTime),
        closeTime: _formatValueTime(_closeTime),
        operatingDays: _getSelectedToValue(_selectedDays, _days),
        payMethods: _getSelectedToValue(_selectedPaymentMethods, _payments),
        currentLatitude: userLocation.latitude,
        currentLongitude: userLocation.longitude,
      );
      logger.d("data ${storeInfo.toJson()}");

      final dialogResult = await showChoiceDialog(context,
          title: "가게 정보 수정은 불가능해요!", message: "입력한 정보로 가게를 등록할까요?");
      logger.d("dialog result : $dialogResult");

      if (dialogResult == true) {
        final response = await storeService.addStore(storeInfo);
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "가게를 등록했어요",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          if (mounted) {
            setState(() {
              isLoading = false; // 로딩 상태를 false로 전환
            });
            Navigator.of(context).popUntil(ModalRoute.withName("/add"));
            Navigator.pop(context);
          }
        } else if (response.statusCode == 400) {
          if (mounted) {
            setState(() {
              isLoading = false; // 로딩 상태를 false로 전환
            });
            showAlertDialog(
              context,
              title: "위치 오류",
              message: response.message,
            );
          }
        } else {
          if (mounted) {
            setState(() {
              isLoading = false; // 로딩 상태를 false로 전환
            });
            showAlertDialog(
              context,
              title: "에러",
              message: "오류가 발생했습니다.",
            );
          }
        }
      }
    }
  }

  // 폼이 원하는 값이 다 채워졌는지 확인하는 함수
  void _validateForm() {
    bool formValid = _formKey.currentState?.validate() ?? false;
    bool toggleValid =
        _selectedDays.contains(true) && _selectedPaymentMethods.contains(true);
    setState(() {
      _isFormValid = formValid && toggleValid;
    });
  }

  // 현재 시간을 minuteInterval에 맞춰서 설정하는 함수
  DateTime _getInitDate({required int minuteInterval}) {
    final now = DateTime.now();
    final int newMin = (now.minute ~/ minuteInterval) * minuteInterval;
    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      newMin,
    );
  }

  // 시간선택 화면 보여줌
  void _showCupertinoTimePicker(BuildContext context,
      {required bool isOpenTime}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time, // 시, 분 선택
            initialDateTime: isOpenTime
                ? (_openTime ?? _initialTime)
                : (_closeTime ?? _initialTime),
            minuteInterval: 5,
            use24hFormat: false,
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                if (isOpenTime) {
                  _openTime = newTime;
                  _openTimeController.text = _formatViewTime(_openTime);
                } else {
                  _closeTime = newTime;
                  _closeTimeController.text = _formatViewTime(_closeTime);
                }
              });
            },
          ),
        );
      },
    );
  }

  // 입력받은 시간을 보여줄 문자열로 포맷팅하는 함수
  String _formatViewTime(DateTime? time) {
    if (time == null) return "시간 선택";

    return _timeFormatter.format(time);
  }

  // 입력받은 시간을 요청에 사용할 값으로 포맷팅하는 함수
  String? _formatValueTime(DateTime? time) {
    if (time == null) return null;
    return _timeValueFormatter.format(time);
  }

  // 한글 값을 요청에 넣을 영어로 바꿔줌
  String korToEng(String text) {
    return switch (text) {
      "일" => "SUN",
      "월" => "MON",
      "화" => "TUE",
      "수" => "WED",
      "목" => "THU",
      "금" => "FRI",
      "토" => "SAT",
      "현금" => "CASH",
      "계좌이체" => "TRANSFER",
      "카드" => "CARD",
      _ => "NOT FOUND"
    };
  }

  // 토글의 selected 리스트를 요청에 보낼 값으로 변환
  List<String> _getSelectedToValue(
      List<bool> selectedList, List<String> korViewList) {
    if (selectedList.length != korViewList.length) return [];
    List<String> result = selectedList
        .asMap()
        .entries
        .where((entry) => entry.value) // 선택된 요소(true)만 필터링
        .map((entry) => korToEng(korViewList[entry.key]))
        .toList();

    // 만약 선택된 요일이 없다면 빈 리스트 반환
    return result;
  }

  // 위젯 함수
  //토글 아이템 디자인
  Container toggleItemContainer({
    required List<bool> selected,
    required MapEntry<int, String> entry,
    required bool isCircle,
    required double itemSize,
    double? margin,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: margin ?? 4.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(12.0),
        color: selected[entry.key]
            ? const Color(0xffF15A2B)
            : const Color(0xFFF4F4F4),
      ),
      width: itemSize,
      height: isCircle ? itemSize : 44,
      child: Center(
        child: Text(entry.value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  // 앱바 디자인
  AppBar addStoreAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
      centerTitle: true,
      title: const Text(
        "가게 등록",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context); //뒤로가기
        },
        icon: const Icon(
          Icons.chevron_left,
          size: 24,
          color: Color(0xFF767676),
        ),
      ),
    );
  }
}
