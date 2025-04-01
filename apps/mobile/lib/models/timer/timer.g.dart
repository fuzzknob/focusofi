// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Timer _$TimerFromJson(Map<String, dynamic> json) => _Timer(
  startTime: DateTime.parse(json['startTime'] as String),
  status: $enumDecode(_$TimerStatusEnumMap, json['status']),
  successionCount: (json['successionCount'] as num).toInt(),
  totalWorkTime: (json['totalWorkTime'] as num).toInt(),
  totalBreakTime: (json['totalBreakTime'] as num).toInt(),
  elapsedPrePause: (json['elapsedPrePause'] as num).toInt(),
);

Map<String, dynamic> _$TimerToJson(_Timer instance) => <String, dynamic>{
  'startTime': instance.startTime.toIso8601String(),
  'status': _$TimerStatusEnumMap[instance.status]!,
  'successionCount': instance.successionCount,
  'totalWorkTime': instance.totalWorkTime,
  'totalBreakTime': instance.totalBreakTime,
  'elapsedPrePause': instance.elapsedPrePause,
};

const _$TimerStatusEnumMap = {
  TimerStatus.idle: 'IDLE',
  TimerStatus.working: 'WORKING',
  TimerStatus.shortBreak: 'SHORT_BREAK',
  TimerStatus.longBreak: 'LONG_BREAK',
  TimerStatus.paused: 'PAUSED',
  TimerStatus.stopped: 'STOPPED',
};
