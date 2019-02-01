String formatTime(Duration duration) {
  int seconds = (duration.inMilliseconds / 1000).truncate();
  int minutes = (seconds / 60).truncate();
  String displayMinutes = (minutes % 60).toString().padLeft(2, '0');
  String displaySeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$displayMinutes:$displaySeconds';
}
