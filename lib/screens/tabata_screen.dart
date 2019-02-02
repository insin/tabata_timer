import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../models.dart';
import '../utils.dart';
import '../widgets/durationpicker.dart';
import 'workout_screen.dart';

class TabataScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabataScreenState();
}

class _TabataScreenState extends State<TabataScreen> {
  Tabata _tabata = defaultTabata;

  _onTabataChanged() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tabata Timer'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
                title: Text(
                  'Sets',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text('${_tabata.sets}'),
                leading: Icon(Icons.fitness_center),
                trailing: Icon(Icons.edit, size: 14),
                onTap: () {
                  showDialog<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return NumberPickerDialog.integer(
                          minValue: 1,
                          maxValue: 10,
                          initialIntegerValue: _tabata.sets,
                          title: Text('Number of sets in the workout'),
                        );
                      }).then((sets) {
                    if (sets == null) return;
                    _tabata.sets = sets;
                    _onTabataChanged();
                  });
                }),
            ListTile(
                title: Text(
                  'Reps',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text('${_tabata.reps}'),
                leading: Icon(Icons.repeat),
                trailing: Icon(Icons.edit, size: 14),
                onTap: () {
                  showDialog<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return NumberPickerDialog.integer(
                          minValue: 1,
                          maxValue: 10,
                          initialIntegerValue: _tabata.reps,
                          title: Text('Number of reps in each set'),
                        );
                      }).then((reps) {
                    if (reps == null) return;
                    _tabata.reps = reps;
                    _onTabataChanged();
                  });
                }),
            Divider(
              height: 10,
            ),
            ListTile(
                title: Text(
                  'Exercise Time',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(formatTime(_tabata.exerciseTime)),
                leading: Icon(Icons.timer),
                trailing: Icon(Icons.edit, size: 14),
                onTap: () {
                  showDialog<Duration>(
                      context: context,
                      builder: (BuildContext context) {
                        return DurationPickerDialog(
                          initialDuration: _tabata.exerciseTime,
                          title: Text('Excercise time per rep'),
                        );
                      }).then((exerciseTime) {
                    if (exerciseTime == null) return;
                    _tabata.exerciseTime = exerciseTime;
                    _onTabataChanged();
                  });
                }),
            ListTile(
                title: Text(
                  'Rest Time',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(formatTime(_tabata.restTime)),
                leading: Icon(Icons.timer),
                trailing: Icon(Icons.edit, size: 14),
                onTap: () {
                  showDialog<Duration>(
                      context: context,
                      builder: (BuildContext context) {
                        return DurationPickerDialog(
                          initialDuration: _tabata.restTime,
                          title: Text('Rest time between reps'),
                        );
                      }).then((restTime) {
                    if (restTime == null) return;
                    _tabata.restTime = restTime;
                    _onTabataChanged();
                  });
                }),
            ListTile(
                title: Text(
                  'Break Time',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(formatTime(_tabata.breakTime)),
                leading: Icon(Icons.timer),
                trailing: Icon(Icons.edit, size: 14),
                onTap: () {
                  showDialog<Duration>(
                      context: context,
                      builder: (BuildContext context) {
                        return DurationPickerDialog(
                          initialDuration: _tabata.breakTime,
                          title: Text('Break time between sets'),
                        );
                      }).then((breakTime) {
                    if (breakTime == null) return;
                    _tabata.breakTime = breakTime;
                    _onTabataChanged();
                  });
                }),
            Divider(height: 10),
            ListTile(
              title: Text(
                'Total Time',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(formatTime(_tabata.getTotalTime())),
              leading: Icon(Icons.timelapse),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkoutScreen(tabata: _tabata)));
          },
          tooltip: 'Start Workout',
          child: Icon(Icons.play_arrow),
        ));
  }
}
