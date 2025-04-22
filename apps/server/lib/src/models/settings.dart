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

  Map<String, Object?> toJson() {
    return {
      'workLength': workLength,
      'shortBreakLength': shortBreakLength,
      'longBreakLength': longBreakLength,
      'breakSuccessions': breakSuccessions,
    };
  }
}
