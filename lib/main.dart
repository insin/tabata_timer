import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'screens/tabata_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  var prefs = await SharedPreferences.getInstance();
  runApp(TimerApp(settings: Settings(prefs), prefs: prefs));
}

class TimerApp extends StatefulWidget {
  final Settings settings;
  final SharedPreferences prefs;

  TimerApp({required this.settings, required this.prefs});

  @override
  State<StatefulWidget> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  _onSettingsChanged() {
    setState(() {});
    widget.settings.save();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabata Timer',
      theme: ThemeData(
        primarySwatch: widget.settings.primarySwatch,
        brightness:
            widget.settings.nightMode ? Brightness.dark : Brightness.light,
      ),
      home: TabataScreen(
        settings: widget.settings,
        prefs: widget.prefs,
        onSettingsChanged: _onSettingsChanged,
      ),
    );
  }
}
