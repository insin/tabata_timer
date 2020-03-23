import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DurationPickerDialog extends StatefulWidget {
  final Duration initialDuration;
  final EdgeInsets titlePadding;
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  DurationPickerDialog({
    @required this.initialDuration,
    this.title,
    this.titlePadding,
    Widget confirmWidget,
    Widget cancelWidget,
  })  : confirmWidget = confirmWidget ?? new Text('OK'),
        cancelWidget = cancelWidget ?? new Text('CANCEL');

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
      content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        new NumberPicker.integer(
          listViewWidth: 65,
          initialValue: minutes,
          minValue: 0,
          maxValue: 10,
          zeroPad: true,
          onChanged: (value) {
            this.setState(() {
              minutes = value;
            });
          },
        ),
        Text(
          ':',
          style: TextStyle(fontSize: 30),
        ),
        new NumberPicker.integer(
          listViewWidth: 65,
          initialValue: seconds,
          minValue: 0,
          maxValue: 59,
          zeroPad: true,
          onChanged: (value) {
            this.setState(() {
              seconds = value;
            });
          },
        ),
      ]),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context)
              .pop(new Duration(minutes: minutes, seconds: seconds)),
          child: widget.confirmWidget,
        ),
      ],
    );
  }
}
