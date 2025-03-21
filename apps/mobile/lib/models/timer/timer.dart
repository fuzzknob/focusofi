import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer.freezed.dart';
part 'timer.g.dart';

enum TimerStatus {
  @JsonValue('IDLE')
  idle,
  @JsonValue('WORKING')
  working,
  @JsonValue('SHORT_BREAK')
  shortBreak,
  @JsonValue('LONG_BREAK')
  longBreak,
  @JsonValue('PAUSED')
  paused,
  @JsonValue('STOPPED')
  stopped,
}

@freezed
sealed class Timer with _$Timer {
  const factory Timer({
    required DateTime startTime,
    required TimerStatus status,
    required int successionCount,
    required int totalWorkTime,
    required int totalBreakTime,
    required int elapsedPrePause,
  }) = _Timer;

  factory Timer.fromJson(Map<String, Object?> json) => _$TimerFromJson(json);
}
