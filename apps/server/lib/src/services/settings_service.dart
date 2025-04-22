import 'package:lucore/lucore.dart';

import '../models/settings.dart';

Future<Settings> createSettings(
  int userId, {
  int workLength = 2400,
  int shortBreakLength = 120,
  int longBreakLength = 600,
  int breakSuccessions = 4,
}) {
  return Settings.db.create(
    userId: userId,
    workLength: workLength,
    shortBreakLength: shortBreakLength,
    longBreakLength: longBreakLength,
    breakSuccessions: breakSuccessions,
  );
}

Future<Settings?> findSettings(int userId) {
  return Settings.db.where('user_id', userId).first();
}

Future<Settings> getSettingsOrThrow(int userId) async {
  final settings = await findSettings(userId);
  if (settings == null) {
    throw LunartException(
      message: 'Data inconsistency',
      error: 'Settings for user  {$userId} not found!',
    );
  }
  return settings;
}
