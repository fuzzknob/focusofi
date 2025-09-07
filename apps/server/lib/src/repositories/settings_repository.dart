import '../models/settings.dart';
import 'repository.dart';

class SettingsRepository extends Repository<Settings> {
  @override
  String get table => 'settings';

  Future<Settings> create({
    required int workLength,
    required int shortBreakLength,
    required int longBreakLength,
    required int workSessions,
    required int userId,
    required bool progressive,
  }) async {
    return save(
      Settings(
        workLength: workLength,
        shortBreakLength: shortBreakLength,
        longBreakLength: longBreakLength,
        workSessions: workSessions,
        userId: userId,
        progressive: progressive,
      ),
    );
  }

  @override
  Settings mapToModel(Map<String, Object?> map) {
    return Settings(
      id: map['id'] as int,
      workSessions: map['work_sessions'] as int,
      longBreakLength: map['long_break_length'] as int,
      shortBreakLength: map['short_break_length'] as int,
      workLength: map['work_length'] as int,
      userId: map['user_id'] as int,
      progressive: map['progressive'] != 0,
    );
  }

  @override
  Map<String, Object?> modelToMap(Settings model) {
    return {
      'work_sessions': model.workSessions,
      'long_break_length': model.longBreakLength,
      'short_break_length': model.shortBreakLength,
      'work_length': model.workLength,
      'user_id': model.userId,
      'progressive': model.progressive,
    };
  }
}
