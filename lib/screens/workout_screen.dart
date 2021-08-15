import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import '../models.dart';
import '../utils.dart';

String stepName(WorkoutState step) {
  switch (step) {
    case WorkoutState.exercising:
      return 'Exercise';
    case WorkoutState.resting:
      return 'Rest';
    case WorkoutState.breaking:
      return 'Break';
    case WorkoutState.finished:
      return 'Finished';
    case WorkoutState.starting:
      return 'Starting';
    default:
      return '';
  }
}

class WorkoutScreen extends StatefulWidget {
  final Settings settings;
  final Tabata tabata;

  WorkoutScreen({required this.settings, required this.tabata});

  @override
  State<StatefulWidget> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Workout _workout;

  @override
  initState() {
    super.initState();
    _workout = Workout(widget.settings, widget.tabata, _onWorkoutChanged);
    _start();
  }

  @override
  dispose() {
    _workout.dispose();
    Wakelock.disable();
    super.dispose();
  }

  _onWorkoutChanged() {
    if (_workout.step == WorkoutState.finished) {
      Wakelock.disable();
    }
    this.setState(() {});
  }

  _getBackgroundColor(ThemeData theme) {
    switch (_workout.step) {
      case WorkoutState.exercising:
        return Colors.green;
      case WorkoutState.starting:
      case WorkoutState.resting:
        return Colors.blue;
      case WorkoutState.breaking:
        return Colors.red;
      default:
        return theme.scaffoldBackgroundColor;
    }
  }

  _pause() {
    _workout.pause();
    Wakelock.disable();
  }

  _start() {
    _workout.start();
    Wakelock.enable();
  }

  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var lightTextColor = theme.textTheme.bodyText2?.color?.withOpacity(0.8);
    return Scaffold(
      body: Container(
        color: _getBackgroundColor(theme),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Expanded(child: Row()),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(stepName(_workout.step), style: TextStyle(fontSize: 60.0))
            ]),
            Divider(height: 32, color: lightTextColor),
            Container(
                width: MediaQuery.of(context).size.width,
                child: FittedBox(child: Text(formatTime(_workout.timeLeft)))),
            Divider(height: 32, color: lightTextColor),
            Table(columnWidths: {
              0: FlexColumnWidth(0.5),
              1: FlexColumnWidth(0.5),
              2: FlexColumnWidth(1.0)
            }, children: [
              TableRow(children: [
                TableCell(child: Text('Set', style: TextStyle(fontSize: 30.0))),
                TableCell(child: Text('Rep', style: TextStyle(fontSize: 30.0))),
                TableCell(
                    child: Text('Total Time',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 30.0)))
              ]),
              TableRow(children: [
                TableCell(
                  child:
                      Text('${_workout.set}', style: TextStyle(fontSize: 60.0)),
                ),
                TableCell(
                  child:
                      Text('${_workout.rep}', style: TextStyle(fontSize: 60.0)),
                ),
                TableCell(
                    child: Text(
                  formatTime(_workout.totalTime),
                  style: TextStyle(fontSize: 60.0),
                  textAlign: TextAlign.right,
                ))
              ]),
            ]),
            Expanded(child: _buildButtonBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonBar() {
    if (_workout.step == WorkoutState.finished) {
      return Container();
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        onPressed: _workout.isActive ? _pause : _start,
        child: Icon(_workout.isActive ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
