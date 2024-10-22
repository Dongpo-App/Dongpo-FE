import 'package:dongpo_test/models/user_add_store.dart';
import 'package:dongpo_test/screens/my_info/info_detail/add_store_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main/main_03/main_03.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({super.key});

  @override
  State<AddStorePage> createState() => AddStorePageState();
}

class AddStorePageState extends State<AddStorePage> {
  AddStoreViewModel viewModel = AddStoreViewModel();
  // 로딩
  bool isLoading = false;

  late List<UserAddStore> _userAddStore = [];

  @override
  void initState() {
    super.initState();
    getUserAddStore();
  }

  void getUserAddStore() async {
    setState(() {
      isLoading = true; // 초기화
    });
    _userAddStore = await viewModel.userAddStoreGetAPI(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "등록한 가게",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
      ),
      body: _userAddStore.isEmpty
          ? const Center(
              child: Text(
                "",
              ),
            )
          : isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ListView.builder(
                  itemCount: _userAddStore.length,
                  itemBuilder: (context, index) {
                    var addStore = _userAddStore[index];
                    return GestureDetector(
                      onTap: () {
                        // 버튼이 눌리면 해당 점포 상세 페이지로 이동
                        Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return StoreInfo(idx: addStore.id);
                        }));
                      },
                      child: Card(
                        elevation: 0,
                        color: const Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    AssetImage('assets/images/icon.png'),
                              ),
                              const SizedBox(
                                // 테스트용
                                width: 30,
                              ),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        addStore.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        // 테스트용
                                        height: 4,
                                      ),
                                      Text(
                                        addStore.address,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 1, // 한 줄로 제한
                                        overflow: TextOverflow.ellipsis, // 줄임표 (...) 추가
                                      ),
                                    ]
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
