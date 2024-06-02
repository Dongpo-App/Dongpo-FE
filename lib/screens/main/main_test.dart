import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Time Picker Example'),
        ),
        body: const Center(
          child: SimpleTimePickerWidget(),
        ),
      ),
    );
  }
}

class SimpleTimePickerWidget extends StatefulWidget {
  const SimpleTimePickerWidget({super.key});

  @override
  _SimpleTimePickerWidgetState createState() => _SimpleTimePickerWidgetState();
}

class _SimpleTimePickerWidgetState extends State<SimpleTimePickerWidget> {
  String _selectedTime = '시간을 선택하세요';

  void _showTimePicker() {
    DatePicker.showTime12hPicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        setState(() {
          final hour = time.hour == 0 ? 12 : time.hour;
          final period = time == DayPeriod.am ? '오전' : '오후';
          _selectedTime = '$period $hour시';
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.ko,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _selectedTime,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _showTimePicker,
          child: const Text('시간 선택하기'),
        ),
      ],
    );
  }
}
