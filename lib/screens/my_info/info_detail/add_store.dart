import 'package:dongpo_test/models/user_add_store.dart';
import 'package:dongpo_test/screens/my_info/info_detail/add_store_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({super.key});

  @override
  State<AddStorePage> createState() => AddStorePageState();
}

class AddStorePageState extends State<AddStorePage> {
  AddStoreViewModel viewModel = AddStoreViewModel();

  late List<UserAddStore> _userAddStore = [
  ];

  @override
  void initState() {
    super.initState();
    getUserAddStore();
  }
  void getUserAddStore() async {
    _userAddStore = await viewModel.userAddStoreGetAPI(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "등록한 가게",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 24,
              color: Color(0xFF767676),
            )),
      ),
      body: _userAddStore.isEmpty
      ? const Center(
          child: Text(
            "",
          ),
        )
      : Padding(
        padding: const EdgeInsets.only(top: 24),
        child: ListView.builder(
          itemCount: _userAddStore.length,
          itemBuilder: (context, index) {
            var addStore = _userAddStore[index];
            return Card(
              elevation: 0,
              color: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 24
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(
                          'assets/images/icon.png'
                      ),
                    ),
                    SizedBox( // 테스트용
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userAddStore[index].name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(// 테스트용
                          height: 4,
                        ),
                        Text(
                          _userAddStore[index].address,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
