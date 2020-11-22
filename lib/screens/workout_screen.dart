import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';

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

  WorkoutScreen({this.settings, this.tabata});

  @override
  State<StatefulWidget> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Workout _workout;

  @override
  initState() {
    super.initState();
    _workout = Workout(widget.settings, widget.tabata, _onWorkoutChanged);
    _start();
  }

  @override
  dispose() {
    _workout.dispose();
    Screen.keepOn(false);
    super.dispose();
  }

  _onWorkoutChanged() {
    if (_workout.step == WorkoutState.finished) {
      Screen.keepOn(false);
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
    Screen.keepOn(false);
  }

  _start() {
    _workout.start();
    Screen.keepOn(true);
  }

  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var lightTextColor = theme.textTheme.bodyText2.color.withOpacity(0.8);
    return Scaffold(
      body: Container(
        color: _getBackgroundColor(theme),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Expanded(child: Row()),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(stepName(_workout.step), style: TextStyle(fontSize: 40.0))
            ]),
            Divider(height: 32, color: lightTextColor),
            AutoSizeText(formatTime(_workout.timeLeft),
                style: TextStyle(fontSize: 200.0), maxLines: 1),
            Divider(height: 32, color: lightTextColor),
            Table(columnWidths: {
              0: FlexColumnWidth(0.5),
              1: FlexColumnWidth(0.5),
              2: FlexColumnWidth(1.0)
            }, children: [
              TableRow(children: [
                TableCell(child: Text('Set', style: TextStyle(fontSize: 18.0))),
                TableCell(child: Text('Rep', style: TextStyle(fontSize: 18.0))),
                TableCell(
                    child: Text('Total Time',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 18.0)))
              ]),
              TableRow(children: [
                TableCell(
                    child: Row(children: [
                  Text('${_workout.set}', style: TextStyle(fontSize: 30.0)),
                  Text(' / ${_workout.config.sets}',
                      style: TextStyle(color: lightTextColor))
                ])),
                TableCell(
                    child: Row(children: [
                  Text('${_workout.rep}', style: TextStyle(fontSize: 30.0)),
                  Text(' / ${_workout.config.reps}',
                      style: TextStyle(color: lightTextColor))
                ])),
                TableCell(
                    child: Text(
                  formatTime(_workout.totalTime),
                  style: TextStyle(fontSize: 30.0),
                  textAlign: TextAlign.right,
                ))
              ]),
              TableRow(children: [
                TableCell(child: Text('')),
                TableCell(child: Text('')),
                TableCell(
                  child: Text(
                    ' / ${formatTime(_workout.config.getTotalTime())}',
                    style: TextStyle(color: lightTextColor),
                    textAlign: TextAlign.right,
                  ),
                )
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
        child: FlatButton(
            onPressed: _workout.isActive ? _pause : _start,
            child: Icon(_workout.isActive ? Icons.pause : Icons.play_arrow)));
  }
}
