import 'dart:async';

import 'package:lucore/lucore.dart';
import 'package:acanthis/acanthis.dart' as acanthis;

import '../libs/utils.dart';
import '../middlewares/auth_middlwares.dart';
import '../services/timer_service.dart' as timer_service;

Future<Response> index(Request req) async {
  final user = getUserOrThrow(req);

  final timer = await timer_service.getTimer(user.id!);

  return res.json(timer?.toJson());
}

final startTimerSchema = acanthis.object({
  'startTime': acanthis.string().dateTime(),
});

Future<Response> start(Request req) async {
  final result = await validate(req, startTimerSchema);
  final user = getUserOrThrow(req);

  await timer_service.startTimer(
    userId: user.id!,
    startTime: _pDT(result['startTime']),
  );

  return res.message('Timer started');
}

final stopTimerSchema = acanthis.object({
  'endTime': acanthis.string().dateTime(),
  'totalWorkTime': acanthis.number(),
  'totalBreakTime': acanthis.number(),
});

Future<Response> stop(Request req) async {
  final result = await validate(req, stopTimerSchema);
  final user = getUserOrThrow(req);

  await timer_service.stopTimer(
    endTime: _pDT(result['endTime']),
    totalBreakTime: result['totalBreakTime'] as int,
    totalWorkTime: result['totalWorkTime'] as int,
    userId: user.id!,
  );

  return res.message('Timer stopped');
}

Future<Response> reset(Request req) async {
  final user = getUserOrThrow(req);

  await timer_service.resetTimer(userId: user.id!);

  return res.message('Timer reset');
}

final pauseTimerSchema = acanthis.object({
  'elapsedPrePause': acanthis.number(),
  'successionCount': acanthis.number(),
  'totalWorkTime': acanthis.number(),
  'totalBreakTime': acanthis.number(),
});

Future<Response> pause(Request req) async {
  final result = await validate(req, pauseTimerSchema);
  final user = getUserOrThrow(req);

  await timer_service.pauseTimer(
    elapsedPrePause: result['elapsedPrePause'],
    successionCount: result['successionCount'],
    totalBreakTime: result['totalBreakTime'],
    totalWorkTime: result['totalWorkTime'],
    userId: user.id!,
  );

  return res.message('Timer paused');
}

final resumeTimerSchema = acanthis.object({
  'startTime': acanthis.string().dateTime(),
});

Future<Response> resume(Request req) async {
  final result = await validate(req, resumeTimerSchema);
  final user = getUserOrThrow(req);

  await timer_service.resumeTimer(
    startTime: _pDT(result['startTime']),
    userId: user.id!,
  );

  return res.message('Timer resumed');
}

final endBreakSchema = acanthis.object({
  'startTime': acanthis.string().dateTime(),
  'successionCount': acanthis.number(),
  'totalWorkTime': acanthis.number(),
  'totalBreakTime': acanthis.number(),
});

Future<Response> endBreak(Request req) async {
  final result = await validate(req, endBreakSchema);
  final user = getUserOrThrow(req);

  await timer_service.endBreak(
    userId: user.id!,
    startTime: _pDT(result['startTime']),
    successionCount: result['successionCount'],
    totalWorkTime: result['totalWorkTime'],
    totalBreakTime: result['totalBreakTime'],
  );

  return res.message('Break ended');
}

DateTime _pDT(String result) => DateTime.parse(result);

Router timerRoutes() {
  return Router.nest('/timer', middlewares: [authGuard])
      .get('/', index)
      .post('/start', start)
      .post('/stop', stop)
      .post('/reset', reset)
      .post('/pause', pause)
      .post('/resume', resume)
      .post('/end-break', endBreak);
}
