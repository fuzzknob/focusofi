import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
sealed class Settings with _$Settings {
  const factory Settings({
    required int workLength,
    required int shortBreakLength,
    required int longBreakLength,
    required int breakSuccessions,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}
