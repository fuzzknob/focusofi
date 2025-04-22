import '../models/settings.dart';
import 'repository.dart';

class SettingsRepository extends Repository<Settings> {
  @override
  String get table => 'settings';

  Future<Settings> create({
    required int workLength,
    required int shortBreakLength,
    required int longBreakLength,
    required int breakSuccessions,
    required int userId,
  }) async {
    return save(
      Settings(
        workLength: workLength,
        shortBreakLength: shortBreakLength,
        longBreakLength: longBreakLength,
        breakSuccessions: breakSuccessions,
        userId: userId,
      ),
    );
  }

  @override
  Settings mapToModel(Map<String, Object?> map) {
    return Settings(
      id: map['id'] as int,
      breakSuccessions: map['break_successions'] as int,
      longBreakLength: map['long_break_length'] as int,
      shortBreakLength: map['short_break_length'] as int,
      workLength: map['work_length'] as int,
      userId: map['user_id'] as int,
    );
  }

  @override
  Map<String, Object?> modelToMap(Settings model) {
    return {
      'break_successions': model.breakSuccessions,
      'long_break_length': model.longBreakLength,
      'short_break_length': model.shortBreakLength,
      'work_length': model.workLength,
      'user_id': model.userId,
    };
  }
}
