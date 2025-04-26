import 'package:lucore/lucore.dart';

import '../models/timer.dart';
import '../models/settings.dart';
import '../events/timer_event.dart';

import 'settings_service.dart' as settings_service;
import 'history_service.dart' as history_service;

Future<Timer?> getTimer(int userId, {bool calculateCurrentState = true}) async {
  final timer = await Timer.db.where('user_id', userId).first();

  if (timer == null) return null;

  if (!calculateCurrentState) {
    return timer;
  }

  final settings = await settings_service.getSettingsOrThrow(userId);

  final currentTimer = calculateCurrentTimerStatus(
    timer: timer.copyWith(),
    settings: settings,
  );

  // save only if there is a change
  if (currentTimer.status != timer.status ||
      currentTimer.successionCount != timer.successionCount ||
      currentTimer.startTime != timer.startTime) {
    await currentTimer.save();
  }

  return currentTimer;
}

Future<Timer> startTimer({
  required DateTime startTime,
  required int userId,
}) async {
  var timer = await getTimer(userId);

  if (timer != null) {
    throw BadRequestException('Timer already started');
  }

  final settings = await settings_service.getSettingsOrThrow(userId);

  timer = await Timer.db.create(
    startTime: startTime,
    timerStartedAt: startTime,
    userId: userId,
    successionCount: settings.breakSuccessions,
    status: TimerStatus.working,
    breakTillStatusChange: 0,
    elapsedPrePause: 0,
    workTillStatusChange: 0,
  );

  TimerEvent(
    action: TimerAction.start,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Future<Timer> stopTimer({
  required int userId,
  required DateTime endTime,
  required int totalBreakTime,
  required int totalWorkTime,
}) async {
  final timer = await getTimer(userId);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  timer.status = TimerStatus.stopped;
  timer.breakTillStatusChange = totalBreakTime;
  timer.workTillStatusChange = totalWorkTime;

  await timer.save();

  await history_service.createHistory(
    name: '',
    startTime: timer.timerStartedAt,
    endTime: endTime,
    totalWorkTime: totalWorkTime,
    totalBreakTime: totalBreakTime,
    userId: userId,
  );

  TimerEvent(action: TimerAction.stop, userId: userId, timer: timer).dispatch();

  return timer;
}

Future<Timer> resetTimer({required int userId}) async {
  final timer = await getTimer(userId, calculateCurrentState: false);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  await timer.delete();

  TimerEvent(
    action: TimerAction.reset,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Future<Timer> pauseTimer({
  required int userId,
  required int elapsedPrePause,
  required int successionCount,
  required int totalWorkTime,
  required int totalBreakTime,
}) async {
  final timer = await getTimer(userId, calculateCurrentState: false);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  timer.status = TimerStatus.paused;
  timer.elapsedPrePause = elapsedPrePause;
  timer.successionCount = successionCount;
  timer.workTillStatusChange = totalWorkTime;
  timer.breakTillStatusChange = totalBreakTime;

  await timer.save();

  TimerEvent(
    action: TimerAction.pause,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Future<Timer> resumeTimer({
  required DateTime startTime,
  required int userId,
}) async {
  final timer = await getTimer(userId, calculateCurrentState: false);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  timer.startTime = startTime;
  timer.status = TimerStatus.working;
  timer.elapsedPrePause = 0;

  await timer.save();

  TimerEvent(
    action: TimerAction.resume,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Future<Timer> endBreak({
  required int userId,
  required DateTime startTime,
  required int successionCount,
  required int totalWorkTime,
  required int totalBreakTime,
}) async {
  final timer = await getTimer(userId, calculateCurrentState: false);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  timer.status = TimerStatus.working;
  timer.startTime = startTime;
  timer.successionCount = successionCount;
  timer.workTillStatusChange = totalWorkTime;
  timer.breakTillStatusChange = totalBreakTime;

  await timer.save();

  TimerEvent(
    action: TimerAction.endBreak,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Timer calculateCurrentTimerStatus({
  required Timer timer,
  required Settings settings,
}) {
  final now = DateTime.now();

  while (true) {
    if (timer.status == TimerStatus.working) {
      final statusEndTime = timer.startTime.add(
        Duration(seconds: settings.workLength),
      );

      if (statusEndTime.isBefore(now)) {
        if (timer.successionCount <= 1) {
          timer.status = TimerStatus.longBreak;
          timer.successionCount = settings.breakSuccessions;
        } else {
          timer.status = TimerStatus.shortBreak;
          timer.successionCount -= 1;
        }

        timer.workTillStatusChange += settings.workLength;
        timer.startTime = statusEndTime;

        continue;
      }

      timer.workTillStatusChange +=
          settings.workLength - statusEndTime.difference(now).inSeconds;
    } else if (timer.status == TimerStatus.shortBreak) {
      final statusEndTime = timer.startTime.add(
        Duration(seconds: settings.shortBreakLength),
      );

      if (statusEndTime.isBefore(now)) {
        timer.status = TimerStatus.working;
        timer.startTime = statusEndTime;
        timer.breakTillStatusChange += settings.shortBreakLength;

        continue;
      }

      timer.breakTillStatusChange =
          settings.shortBreakLength - statusEndTime.difference(now).inSeconds;
    } else if (timer.status == TimerStatus.longBreak) {
      final statusEndTime = timer.startTime.add(
        Duration(seconds: settings.longBreakLength),
      );

      if (statusEndTime.isBefore(now)) {
        timer.status = TimerStatus.working;
        timer.startTime = statusEndTime;
        timer.breakTillStatusChange += settings.longBreakLength;

        continue;
      }

      timer.breakTillStatusChange +=
          settings.longBreakLength - statusEndTime.difference(now).inSeconds;
    }

    return timer;
  }
}
