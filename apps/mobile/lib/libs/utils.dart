import 'package:flutter_dotenv/flutter_dotenv.dart';

({int hours, int minutes, int seconds}) formatSecondsToTime(int s) {
  var seconds = s;
  var hours = 0;
  var minutes = 0;
  if (seconds >= 3600) {
    hours = (seconds / 3600).floor();
    seconds -= hours * 3600;
  }
  if (seconds >= 60) {
    minutes = (seconds / 60).floor();
    seconds -= minutes * 60;
  }
  return (hours: hours, minutes: minutes, seconds: seconds);
}

String? getEnvVariable(String name, {bool isRequired = true}) {
  final value = dotenv.env[name];
  if ((value == null || value.isEmpty) && isRequired) {
    throw ('$name is required');
  }
  return value;
}
