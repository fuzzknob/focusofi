import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomo_mobile/models/timer/timer.dart';
import 'package:pomo_mobile/providers/auth.dart' show authRequestProvider;
import 'package:pomo_mobile/providers/settings.dart';
import 'package:pomo_mobile/services/timer_service.dart';

final timerProvider = StateProvider<Timer?>((_) => null);

final countdownProvider = StateProvider<int>((_) => 0);

final calculateTimeProvider = Provider((ref) {
  return ({Timer? current}) {
    final timer = current ?? ref.read(timerProvider);
    final settings = ref.read(settingsProvider);
    if (timer == null || settings == null) return;
    if (timer.status == TimerStatus.paused) {
      return;
    }
    var length = switch (timer.status) {
      (TimerStatus.working) => settings.workLength,
      (TimerStatus.longBreak) => settings.longBreakLength,
      (TimerStatus.shortBreak) => settings.shortBreakLength,
      _ => 0,
    };
    final statusEndTime = timer.startTime.add(Duration(seconds: length));
    final difference = statusEndTime.difference(DateTime.now());
    ref.read(countdownProvider.notifier).state = difference.inSeconds;
  };
});

final tickProvider = Provider((ref) {
  return () {
    final timer = ref.read(timerProvider);
    final settings = ref.read(settingsProvider);
    final countdown = ref.read(countdownProvider);
    if (timer == null || settings == null) return;
    final calculateTime = ref.read(calculateTimeProvider);

    TimerStatus status = timer.status;
    int successionCount = timer.successionCount;
    if (status == TimerStatus.working) {
      if (countdown <= 0) {
        if (successionCount <= 1) {
          status = TimerStatus.longBreak;
          successionCount = settings.breakSuccessions;
          // TODO: notify
        } else {
          status = TimerStatus.shortBreak;
          successionCount = successionCount - 1;
        }
        final current = timer.copyWith(
          startTime: timer.startTime.add(
            Duration(seconds: settings.workLength),
          ),
          status: status,
          successionCount: successionCount,
        );
        ref.read(timerProvider.notifier).state = current;
        calculateTime(current: current);
        return;
      }
      calculateTime();
      return;
    }
    if (status == TimerStatus.longBreak || status == TimerStatus.shortBreak) {
      if (countdown <= 0) {
        // TODO: notify
        final current = timer.copyWith(
          startTime: timer.startTime.add(
            Duration(
              seconds:
                  status == TimerStatus.longBreak
                      ? settings.longBreakLength
                      : settings.shortBreakLength,
            ),
          ),
          status: TimerStatus.working,
        );
        ref.read(timerProvider.notifier).state = current;
        calculateTime(current: current);
        return;
      }
      calculateTime();
    }
  };
});

final timerServiceProvider = Provider((ref) {
  final request = ref.watch(authRequestProvider);
  if (request == null) return null;
  return TimerService(request: request);
});

final getTimerProvider = Provider((ref) {
  return () async {
    final timerService = ref.read(timerServiceProvider);
    if (timerService == null) {
      return;
    }
    final timer = await timerService.fetchTimer();
    if (timer == null) {
      return;
    }
    ref.read(timerProvider.notifier).state = timer;
    ref.read(calculateTimeProvider)();
  };
});
