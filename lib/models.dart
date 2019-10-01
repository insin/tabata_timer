import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var player = new AudioCache();

var defaultTabata = new Tabata(
    sets: 5,
    reps: 5,
    exerciseTime: new Duration(seconds: 20),
    restTime: new Duration(seconds: 10),
    breakTime: new Duration(seconds: 60));

class Settings {
  final SharedPreferences _prefs;

  bool nightMode;
  Color primarySwatch;
  String countdownPip;
  String startRep;
  String startRest;
  String startBreak;
  String startSet;
  String endWorkout;

  Settings(this._prefs) {
    Map<String, dynamic> json =
        jsonDecode(_prefs.getString('settings') ?? '{}');
    nightMode = json['nightMode'] ?? false;
    primarySwatch = Colors.primaries[
        json['primarySwatch'] ?? Colors.primaries.indexOf(Colors.deepPurple)];
    countdownPip = json['countdownPip'] ?? 'pip.mp3';
    startRep = json['startRep'] ?? 'boop.mp3';
    startRest = json['startRest'] ?? 'dingdingding.mp3';
    startBreak = json['startBreak'] ?? 'dingdingding.mp3';
    startSet = json['startSet'] ?? 'boop.mp3';
    endWorkout = json['endWorkout'] ?? 'dingdingding.mp3';
  }

  save() {
    _prefs.setString('settings', jsonEncode(this));
  }

  Map<String, dynamic> toJson() => {
        'nightMode': nightMode,
        'primarySwatch': Colors.primaries.indexOf(primarySwatch),
        'countdownPip': countdownPip,
        'startRep': startRep,
        'startRest': startRest,
        'startBreak': startBreak,
        'startSet': startSet,
        'endWorkout': endWorkout,
      };
}

class Tabata {
  /// Sets in a workout
  int sets;

  /// Reps in a set
  int reps;

  /// Time to exercise for in each rep
  Duration exerciseTime;

  /// Rest time between reps
  Duration restTime;

  /// Break time between sets
  Duration breakTime;

  Tabata({this.sets, this.reps, this.exerciseTime, this.restTime, this.breakTime});

  Duration getTotalTime() {
    return (exerciseTime * sets * reps) +
        (restTime * sets * (reps - 1)) +
        (breakTime * (sets - 1));
  }
}

enum WorkoutState { initial, exercising, resting, breaking, finished }

class Workout {
  Settings _settings;

  Tabata _config;

  /// Callback for when the workout's state has changed.
  Function _onStateChange;

  WorkoutState _step = WorkoutState.initial;

  Timer _timer;

  /// Time left in the current step
  Duration _timeLeft;

  Duration _totalTime = new Duration(seconds: 0);

  /// Current set
  int _set = 1;

  /// Current rep
  int _rep = 1;

  Workout(this._settings, this._config, this._onStateChange);

  /// Starts or resumes the workout
  start() {
    if (_step == WorkoutState.initial) {
      _step = WorkoutState.exercising;
      _timeLeft = _config.exerciseTime;
    }
    _timer = new Timer.periodic(new Duration(seconds: 1), _tick);
    _onStateChange();
  }

  /// Pauses the workout
  pause() {
    _timer.cancel();
    _onStateChange();
  }

  /// Stops the timer without triggering the state change callback.
  dispose() {
    _timer.cancel();
  }

  _tick(Timer timer) {
    if (_timeLeft == new Duration(seconds: 1)) {
      _nextStep();
    } else {
      _timeLeft -= new Duration(seconds: 1);
      if (_timeLeft.inSeconds <= 3 && _timeLeft.inSeconds >= 1) {
        player.play('pip.mp3');
      }
    }

    _totalTime += new Duration(seconds: 1);

    _onStateChange();
  }

  /// Moves the workout to the next step and sets up state for it.
  _nextStep() {
    if (_step == WorkoutState.exercising) {
      if (rep == _config.reps) {
        if (set == _config.sets) {
          _finish();
        } else {
          _startBreak();
        }
      } else {
        _startRest();
      }
    } else if (_step == WorkoutState.resting) {
      _startRep();
    } else if (_step == WorkoutState.breaking) {
      _startSet();
    }
  }

  _startRest() {
    _step = WorkoutState.resting;
    _timeLeft = _config.restTime;
    player.play(_settings.startRest);
  }

  _startRep() {
    _rep++;
    _step = WorkoutState.exercising;
    _timeLeft = _config.exerciseTime;
    player.play(_settings.startRep);
  }

  _startBreak() {
    _step = WorkoutState.breaking;
    _timeLeft = _config.breakTime;
    player.play(_settings.startBreak);
  }

  _startSet() {
    _set++;
    _rep = 1;
    _step = WorkoutState.exercising;
    _timeLeft = _config.exerciseTime;
    player.play(_settings.startSet);
  }

  _finish() {
    _timer.cancel();
    _step = WorkoutState.finished;
    _timeLeft = new Duration(seconds: 0);
    player.play(_settings.endWorkout).then((p) {
      p.onPlayerCompletion.first.then((_) {
        player.play(_settings.endWorkout);
      });
    });
  }

  get config => _config;

  get set => _set;

  get rep => _rep;

  get step => _step;

  get timeLeft => _timeLeft;

  get totalTime => _totalTime;

  get isActive => _timer != null && _timer.isActive;
}
