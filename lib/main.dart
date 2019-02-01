import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/tabata_screen.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabata Timer',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: TabataScreen(),
    );
  }
}
