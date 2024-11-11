import 'package:dongpo_test/screens/my_info/info_detail/info_title_view_model.dart';
import 'package:flutter/material.dart';
import '../../../models/info_user_title.dart';

class InfoTitlePage extends StatefulWidget {
  const InfoTitlePage({super.key});

  @override
  State<InfoTitlePage> createState() => InfoTitlePageState();
}

class InfoTitlePageState extends State<InfoTitlePage> {
  InfoTitleViewModel viewModel = InfoTitleViewModel();

  late List<InfoUserTitle> _userTitle = [];

  @override
  void initState(){
    super.initState();
    getUserTitle();
  }
  void getUserTitle() async {
    _userTitle = await viewModel.infoUserTitleGetAPI(context);
    setState(() {});
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
          "칭호",
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
            )),
      ),
      body: _userTitle.isEmpty
          ? const Center(
              child: Text(
                "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 24),
              itemCount: _userTitle.length,
              itemBuilder: (context, index) {
                var titles = _userTitle[index];
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
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(
                                'assets/images/icon.png'
                            ),
                          ),
                          const SizedBox( // 테스트용
                            width: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titles.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Text(
                                titles.achieveCondition,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(// 테스트용
                          width: 30,
                        ),
                      ],
                    ),
                ),
              );
            },
        ),
    );
  }
}
