// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
  workLength: (json['workLength'] as num).toInt(),
  shortBreakLength: (json['shortBreakLength'] as num).toInt(),
  longBreakLength: (json['longBreakLength'] as num).toInt(),
  breakSuccessions: (json['breakSuccessions'] as num).toInt(),
);

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
  'workLength': instance.workLength,
  'shortBreakLength': instance.shortBreakLength,
  'longBreakLength': instance.longBreakLength,
  'breakSuccessions': instance.breakSuccessions,
};
