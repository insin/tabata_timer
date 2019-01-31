import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'workout.dart';

void main() => runApp(TimerApp());

String stepName(WorkoutState step) {
  switch (step) {
    case WorkoutState.working:
      return 'Work';
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

String formatTime(Duration duration) {
  int seconds = (duration.inMilliseconds / 1000).truncate();
  int minutes = (seconds / 60).truncate();
  String displayMinutes = (minutes % 60).toString().padLeft(2, '0');
  String displaySeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$displayMinutes:$displaySeconds';
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        dividerColor: Colors.blue,
      ),
      home: MyHomePage(title: 'Timer App'),
    );
  }
}

class TabataSummary extends StatelessWidget {
  final Tabata tabata;

  final Function(Tabata) onChange;

  TabataSummary({this.tabata, this.onChange});

  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text(
                'Sets',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
              ),
              subtitle: Text('${tabata.sets}'),
              leading: Icon(
                Icons.repeat,
              ),
              onTap: () {
                showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return new NumberPickerDialog.integer(
                        minValue: 1,
                        maxValue: 10,
                        initialIntegerValue: tabata.sets,
                        title: Text('Number of sets in the workout'),
                      );
                    }).then((sets) {
                  if (sets == null) return;
                  tabata.sets = sets;
                  onChange(tabata);
                });
              }),
          ListTile(
              title: Text(
                'Reps',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
              ),
              subtitle: Text('${tabata.reps}'),
              leading: Icon(
                Icons.repeat,
              ),
              onTap: () {
                showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return new NumberPickerDialog.integer(
                        minValue: 1,
                        maxValue: 10,
                        initialIntegerValue: tabata.reps,
                        title: Text('Number of reps in each set'),
                      );
                    }).then((reps) {
                  if (reps == null) return;
                  tabata.reps = reps;
                  onChange(tabata);
                });
              }),
          Divider(),
          ListTile(
              title: Text(
                'Work Time',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
              ),
              subtitle: Text(formatTime(tabata.workTime)),
              leading: Icon(Icons.timer),
              onTap: () {
                showDialog<Duration>(
                    context: context,
                    builder: (BuildContext context) {
                      return new DurationPickerDialog(
                        initialDuration: tabata.workTime,
                        title: Text('Excercise time per rep'),
                      );
                    }).then((workTime) {
                  if (workTime == null) return;
                  tabata.workTime = workTime;
                  onChange(tabata);
                });
              }),
          ListTile(
              title: Text(
                'Rest Time',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
              ),
              subtitle: Text(formatTime(tabata.restTime)),
              leading: Icon(Icons.timer),
              onTap: () {
                showDialog<Duration>(
                    context: context,
                    builder: (BuildContext context) {
                      return new DurationPickerDialog(
                        initialDuration: tabata.restTime,
                        title: Text('Rest time between reps'),
                      );
                    }).then((restTime) {
                  if (restTime == null) return;
                  tabata.restTime = restTime;
                  onChange(tabata);
                });
              }),
          ListTile(
              title: Text(
                'Break Time',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
              ),
              subtitle: Text(formatTime(tabata.breakTime)),
              leading: Icon(Icons.timer),
              onTap: () {
                showDialog<Duration>(
                    context: context,
                    builder: (BuildContext context) {
                      return new DurationPickerDialog(
                        initialDuration: tabata.breakTime,
                        title: Text('Break time between sets'),
                      );
                    }).then((breakTime) {
                  if (breakTime == null) return;
                  tabata.breakTime = breakTime;
                  onChange(tabata);
                });
              }),
          Divider(),
          ListTile(
            title: Text(
              'Total Time',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            ),
            subtitle: Text(formatTime(tabata.getTotalTime())),
            leading: Icon(Icons.timelapse),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class DurationPickerDialog extends StatefulWidget {
  final Duration initialDuration;
  final EdgeInsets titlePadding;
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  DurationPickerDialog(
      {@required this.initialDuration,
      this.title,
      this.titlePadding,
      Widget confirmWidget,
      Widget cancelWidget})
      : confirmWidget = confirmWidget ?? new Text("OK"),
        cancelWidget = cancelWidget ?? new Text("CANCEL");

  @override
  State<StatefulWidget> createState() =>
      new _DurationPickerDialogState(initialDuration);
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  int minutes;
  int seconds;

  _DurationPickerDialogState(Duration initialDuration) {
    minutes = initialDuration.inMinutes;
    seconds = initialDuration.inSeconds % Duration.secondsPerMinute;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: Row(children: [
        new NumberPicker.integer(
            initialValue: minutes,
            minValue: 0,
            maxValue: 10,
            onChanged: (value) {
              this.setState(() {
                minutes = value;
              });
            }),
        Text(
          ':',
          style: TextStyle(fontSize: 30),
        ),
        new NumberPicker.integer(
            initialValue: seconds,
            minValue: 0,
            maxValue: 59,
            onChanged: (value) {
              this.setState(() {
                seconds = value;
              });
            }),
      ]),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        new FlatButton(
            onPressed: () => Navigator.of(context)
                .pop(new Duration(minutes: minutes, seconds: seconds)),
            child: widget.confirmWidget),
      ],
    );
  }
}

class WorkoutSummary extends StatelessWidget {
  final Workout workout;

  WorkoutSummary({this.workout});

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(45),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(stepName(workout.step), style: TextStyle(fontSize: 40.0))
              ]),
              Divider(height: 32),
              AutoSizeText(formatTime(workout.timeLeft),
                  style: TextStyle(fontSize: 130.0), maxLines: 1),
              Divider(height: 32),
              Table(children: [
                TableRow(children: [
                  TableCell(
                      child: Text('Set', style: TextStyle(fontSize: 20.0))),
                  TableCell(
                      child: Text('Rep', style: TextStyle(fontSize: 20.0))),
                  TableCell(
                      child: Text(
                    'Total Time',
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.end,
                  ))
                ]),
                TableRow(children: [
                  TableCell(
                      child: Text('${workout.set}',
                          style: TextStyle(fontSize: 40.0))),
                  TableCell(
                      child: Text('${workout.rep}',
                          style: TextStyle(fontSize: 40.0))),
                  TableCell(
                      child: Text(
                    formatTime(workout.totalTime),
                    style: TextStyle(fontSize: 40.0),
                    textAlign: TextAlign.end,
                  ))
                ]),
              ])
            ],
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Tabata _tabata = defaultTabata;

  Workout _workout;

  _updateWorkout(Workout workout) {
    setState(() {
      _workout = workout;
    });
  }

  _updateTabata(Tabata tabata) {
    setState(() {
      _tabata = tabata;
    });
  }

  _startWorkout() {
    var workout = new Workout(_tabata, _updateWorkout);
    workout.start();
    _updateWorkout(workout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _workout == null
          ? new TabataSummary(tabata: _tabata, onChange: _updateTabata)
          : new WorkoutSummary(workout: _workout),
      floatingActionButton: _workout == null
          ? FloatingActionButton(
              onPressed: _startWorkout,
              tooltip: 'Start Workout',
              child: Icon(Icons.play_arrow),
            )
          : null,
    );
  }
}
