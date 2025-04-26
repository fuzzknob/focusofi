import 'package:pomo_server/src/libs/events/event.dart';
import 'package:pomo_server/src/models/timer.dart';

class TimerEvent extends Event {
  const TimerEvent({
    required this.action,
    required this.userId,
    required this.timer,
  });

  final TimerAction action;
  final int userId;
  final Timer timer;

  Map<String, Object> toJson() => {
    'action': action.value,
    'userId': userId,
    'timer': timer.toJson(),
  };
}

enum TimerAction {
  start,
  stop,
  pause,
  resume,
  endBreak,
  reset;

  String get value => toString();

  @override
  String toString() {
    return switch (this) {
      (TimerAction.start) => 'START',
      (TimerAction.stop) => 'STOP',
      (TimerAction.pause) => 'PAUSE',
      (TimerAction.resume) => 'RESUME',
      (TimerAction.endBreak) => 'END_BREAK',
      (TimerAction.reset) => 'RESET',
    };
  }

  TimerAction parse(String action) {
    return switch (action) {
      ('START') => TimerAction.start,
      ('STOP') => TimerAction.stop,
      ('PAUSE') => TimerAction.pause,
      ('RESUME') => TimerAction.resume,
      ('END_BREAK') => TimerAction.endBreak,
      ('RESET') => TimerAction.reset,
      _ => throw Exception('Unknown action => $action'),
    };
  }
}
