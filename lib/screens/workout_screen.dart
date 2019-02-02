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
    default:
      return '';
  }
}

class WorkoutScreen extends StatefulWidget {
  final Tabata tabata;

  WorkoutScreen({this.tabata});

  @override
  State<StatefulWidget> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Workout _workout;

  @override
  initState() {
    super.initState();
    _workout = Workout(widget.tabata, _onWorkoutChanged);
    _start();
  }

  @override
  dispose() {
    _workout.dispose();
    super.dispose();
  }

  _onWorkoutChanged() {
    this.setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Expanded(child: Row()),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(stepName(_workout.step), style: TextStyle(fontSize: 40.0))
            ]),
            Divider(height: 32, color: Theme.of(context).primaryColor),
            AutoSizeText(formatTime(_workout.timeLeft),
                style: TextStyle(fontSize: 130.0), maxLines: 1),
            Divider(height: 32, color: Theme.of(context).primaryColor),
            Table(children: [
              TableRow(children: [
                TableCell(child: Text('Set')),
                TableCell(child: Text('Rep')),
                TableCell(
                    child: Text(
                  'Total Time',
                  textAlign: TextAlign.end,
                ))
              ]),
              TableRow(children: [
                TableCell(
                    child: Row(children: [
                  Text('${_workout.set}', style: TextStyle(fontSize: 30.0)),
                  Text(' / ${_workout.config.sets}',
                      style: TextStyle(color: Colors.grey))
                ])),
                TableCell(
                    child: Row(children: [
                  Text('${_workout.rep}', style: TextStyle(fontSize: 30.0)),
                  Text(' / ${_workout.config.reps}',
                      style: TextStyle(color: Colors.grey))
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
                    style: TextStyle(color: Colors.grey),
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
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FlatButton(
              onPressed: _workout.isActive ? _pause : _start,
              child: Icon(_workout.isActive ? Icons.pause : Icons.play_arrow))
        ]));
  }
}
