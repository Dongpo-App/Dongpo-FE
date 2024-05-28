import 'package:dongpo_test/screens/main/main_01.dart';
import 'package:flutter/material.dart';

void main() async {
  await reset_map();
  return runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Radio buttons';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

int a = 0;

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int value = 0;
  Widget _radioBtn(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          value = index;
          print('$index');
        });
      },
      child: Text(
        text,
        style: TextStyle(
            color: (value == index) ? Colors.white : Colors.grey[600]),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        minimumSize: Size(double.infinity, 40),
        backgroundColor:
            (value == index) ? Color(0xffF15A2B) : Colors.grey[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _radioBtn("Single", 1),
        _radioBtn("Married", 2),
        _radioBtn("Other", 3),
        ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (BuildContext context,
                        StateSetter setState /*You can rename this!*/) {
                      return Container(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() => a += 10);
                              },
                              child: Text('$a'),
                            )
                          ],
                        ),
                      );
                    });
                  });
            },
            child: Text("test"))
      ],
    );
  }
}
