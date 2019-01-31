import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'durationpicker.dart';
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
        primarySwatch: Colors.deepPurple,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        title: Text(_workout == null ? 'Tabata Timer' : 'Workout'),
      ),
      body: _workout == null
          ? new TabataScreen(tabata: _tabata, onChange: _updateTabata)
          : new WorkoutScreen(workout: _workout),
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

class TabataScreen extends StatelessWidget {
  final Tabata tabata;

  final Function(Tabata) onChange;

  TabataScreen({this.tabata, this.onChange});

  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text(
                'Sets',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text('${tabata.sets}'),
              leading: Icon(Icons.fitness_center),
              trailing: Icon(Icons.edit, size: 14),
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
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text('${tabata.reps}'),
              leading: Icon(Icons.repeat),
              trailing: Icon(Icons.edit, size: 14),
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
          Divider(
            height: 10,
          ),
          ListTile(
              title: Text(
                'Work Time',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(formatTime(tabata.workTime)),
              leading: Icon(Icons.timer),
              trailing: Icon(Icons.edit, size: 14),
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
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(formatTime(tabata.restTime)),
              leading: Icon(Icons.timer),
              trailing: Icon(Icons.edit, size: 14),
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
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(formatTime(tabata.breakTime)),
              leading: Icon(Icons.timer),
              trailing: Icon(Icons.edit, size: 14),
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
          Divider(height: 10),
          ListTile(
            title: Text(
              'Total Time',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(formatTime(tabata.getTotalTime())),
            leading: Icon(Icons.timelapse),
          ),
        ],
      ),
    );
  }
}

class WorkoutScreen extends StatelessWidget {
  final Workout workout;

  WorkoutScreen({this.workout});

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(stepName(workout.step), style: TextStyle(fontSize: 40.0))
              ]),
              Divider(height: 32, color: Theme.of(context).primaryColor),
              AutoSizeText(formatTime(workout.timeLeft),
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
                    Text('${workout.set}', style: TextStyle(fontSize: 30.0)),
                    Text(' / ${workout.config.sets}',
                        style: TextStyle(color: Colors.grey))
                  ])),
                  TableCell(
                      child: Row(children: [
                    Text('${workout.rep}', style: TextStyle(fontSize: 30.0)),
                    Text(' / ${workout.config.reps}',
                        style: TextStyle(color: Colors.grey))
                  ])),
                  TableCell(
                      child: Text(
                    formatTime(workout.totalTime),
                    style: TextStyle(fontSize: 30.0),
                    textAlign: TextAlign.right,
                  ))
                ]),
                TableRow(children: [
                  TableCell(child: Text('')),
                  TableCell(child: Text('')),
                  TableCell(
                    child: Text(
                      ' / ${formatTime(workout.config.getTotalTime())}',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
              ])
            ],
          ),
        ));
  }
}
