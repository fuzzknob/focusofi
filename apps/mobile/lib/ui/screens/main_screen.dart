import 'dart:async' as ds;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:pomo_mobile/libs/utils.dart';
import 'package:pomo_mobile/models/timer/timer.dart';
import 'package:pomo_mobile/providers/background.dart';
import 'package:pomo_mobile/providers/timer.dart';
import 'package:pomo_mobile/ui/widgets/account.dart';

import '../layouts/main_layout.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int? _expectedTimeout;
  ds.Timer? _ticker;

  @override
  initState() {
    super.initState();
    _initlizeTimer();
  }

  _initlizeTimer() {
    _ticker?.cancel();
    final timer = ref.read(timerProvider);
    if (timer == null) return;
    ref.read(tickProvider)();
    final start = timer.startTime.millisecond;
    final current = DateTime.now().millisecond;
    final interval = start > current ? start - current : 1000 - current + start;
    _expectedTimeout = DateTime.now().millisecondsSinceEpoch + interval;
    _ticker = ds.Timer(Duration(milliseconds: interval), _tick);
  }

  void _tick() {
    ref.read(tickProvider)();
    final interval = 1000;
    var slippage = 0;
    if (_expectedTimeout != null) {
      slippage = DateTime.now().millisecondsSinceEpoch - _expectedTimeout!;
      _expectedTimeout = _expectedTimeout! + interval;
    } else {
      _expectedTimeout = DateTime.now().millisecondsSinceEpoch + interval;
    }
    _ticker = ds.Timer(Duration(milliseconds: interval - slippage), _tick);
  }

  void _refresh() async {
    await ref.read(getTimerProvider)();
    await ref.read(getBackgroundServiceProvider)();
    _initlizeTimer();
  }

  @override
  dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  ({List<String> minutes, List<String> seconds}) _formatTime(int countdown) {
    final time = formatSecondsToTime(countdown);
    final minutes = time.minutes
        .toString()
        .padLeft(2, 'O')
        .replaceAll('0', 'O')
        .split('');
    final seconds = time.seconds
        .toString()
        .padLeft(2, 'O')
        .replaceAll('0', 'O')
        .split('');
    return (minutes: minutes, seconds: seconds);
  }

  @override
  Widget build(BuildContext context) {
    final countdown = ref.watch(countdownProvider);
    final timer = ref.watch(timerProvider);
    final (:minutes, :seconds) = _formatTime(countdown);

    if (timer == null || timer.status == TimerStatus.stopped) {
      return MainLayout(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(70.0),
              Text('No timer is running', style: TextStyle(fontSize: 25.0)),
              const Gap(20.0),
              IconButton(
                onPressed: _refresh,
                icon: Icon(Icons.refresh_rounded, size: 35.0),
              ),
            ],
          ),
          Positioned(top: 60, right: 20.0, child: Account()),
        ],
      );
    }

    final textStyle = TextStyle(
      fontSize: 200.0,
      color: switch (timer.status) {
        (TimerStatus.paused) => Colors.blue.shade400,
        (TimerStatus.longBreak || TimerStatus.shortBreak) =>
          Colors.green.shade200,
        _ => Colors.white,
      },
    );

    final isSeparatorVisible = countdown % 2 == 0;

    return MainLayout(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 90.0,
                child: Text(
                  minutes[0],
                  textAlign: TextAlign.right,
                  style: textStyle,
                ),
              ),
              SizedBox(
                width: 90.0,
                child: Text(
                  minutes[1],
                  textAlign: TextAlign.right,
                  style: textStyle,
                ),
              ),
              SizedBox(
                width: 40.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSeparatorVisible)
                      Text(':', textAlign: TextAlign.center, style: textStyle),
                    Gap(15.0),
                  ],
                ),
              ),
              SizedBox(width: 90.0, child: Text(seconds[0], style: textStyle)),
              SizedBox(width: 90.0, child: Text(seconds[1], style: textStyle)),
            ],
          ),
        ),
        Positioned(
          top: 60,
          right: 20.0,
          child: Account(
            beforeLogout: () async {
              _ticker?.cancel();
            },
          ),
        ),
        Positioned(
          bottom: 50.0,
          child: IconButton(
            onPressed: _refresh,
            icon: Icon(Icons.refresh_rounded, size: 35.0),
          ),
        ),
      ],
    );
  }
}
