import 'package:lucore/lucore.dart';

import '../models/settings.dart';
import '../events/settings_updated_event.dart';

// import 'timer_service.dart' as timer_service;

Future<Settings> createSettings(
  int userId, {
  int workLength = 2400,
  int shortBreakLength = 120,
  int longBreakLength = 600,
  int workSessions = 4,
}) {
  return Settings.db.create(
    userId: userId,
    workLength: workLength,
    shortBreakLength: shortBreakLength,
    longBreakLength: longBreakLength,
    workSessions: workSessions,
  );
}

Future<Settings> updateSettings(
  int userId, {
  required int workLength,
  required int shortBreakLength,
  required int longBreakLength,
  required int workSessions,
}) async {
  final settings = await getSettingsOrThrow(userId);

  // final oldSettings = settings.copyWith();

  settings.workLength = workLength;
  settings.shortBreakLength = shortBreakLength;
  settings.longBreakLength = longBreakLength;
  settings.workSessions = workSessions;

  await settings.save();

  // TODO: adjust timer
  // final timer = await timer_service.adjustTimerToNewSettings(
  //   userId,
  //   settings,
  //   oldSettings,
  // );

  SettingsUpdatedEvent(
    userId: userId,
    settings: settings,
    // timer: timer,
  ).dispatch();

  return settings;
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
