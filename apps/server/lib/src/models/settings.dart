import '../repositories/settings_repository.dart';

import 'model.dart';

class Settings implements Model {
  Settings({
    this.id,
    required this.workLength,
    required this.shortBreakLength,
    required this.longBreakLength,
    required this.breakSuccessions,
    required this.userId,
  });

  @override
  int? id;

  int workLength;
  int shortBreakLength;
  int longBreakLength;
  int breakSuccessions;
  int userId;

  static SettingsRepository get db => SettingsRepository();

  // The ! at the end is important or else it will delete every records
  Future<void> delete() => db.delete(id!);

  Future<void> save() => db.save(this);

  Settings copyWith({
    int? id,
    int? workLength,
    int? shortBreakLength,
    int? longBreakLength,
    int? breakSuccessions,
    int? userId,
  }) => Settings(
    id: id ?? this.id,
    workLength: workLength ?? this.workLength,
    shortBreakLength: shortBreakLength ?? this.shortBreakLength,
    longBreakLength: longBreakLength ?? this.longBreakLength,
    breakSuccessions: breakSuccessions ?? this.breakSuccessions,
    userId: userId ?? this.userId,
  );

  Map<String, Object?> toJson() {
    return {
      'workLength': workLength,
      'shortBreakLength': shortBreakLength,
      'longBreakLength': longBreakLength,
      'breakSuccessions': breakSuccessions,
    };
  }
}
