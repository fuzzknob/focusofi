import 'dart:async';

import 'package:lucore/lucore.dart';
import 'package:acanthis/acanthis.dart' as acanthis;

import '../libs/utils.dart';

import '../middlewares/auth_middlwares.dart';
import '../services/timer_service.dart' as timer_service;

final eventSchema = acanthis.object({'time': acanthis.string().dateTime()});

Future<DateTime> validateEventRequest(Request req) async {
  final result = await validate(req, eventSchema);
  return _pDT(result['time']);
}

Future<Response> index(Request req) async {
  final user = getUserOrThrow(req);

  final timer = await timer_service.getTimer(user.id!);

  return res.json(timer?.toJson());
}

Future<Response> start(Request req) async {
  final user = getUserOrThrow(req);
  final time = await validateEventRequest(req);

  await timer_service.startTimer(userId: user.id!, time: time);

  return res.message('Timer started');
}

Future<Response> stop(Request req) async {
  final user = getUserOrThrow(req);
  final time = await validateEventRequest(req);

  await timer_service.stopTimer(time: time, userId: user.id!);

  return res.message('Timer stopped');
}

Future<Response> reset(Request req) async {
  final user = getUserOrThrow(req);

  await timer_service.resetTimer(userId: user.id!);

  return res.message('Timer reset');
}

Future<Response> pause(Request req) async {
  final user = getUserOrThrow(req);
  final time = await validateEventRequest(req);

  await timer_service.pauseTimer(time: time, userId: user.id!);

  return res.message('Timer paused');
}

Future<Response> resume(Request req) async {
  final user = getUserOrThrow(req);
  final time = await validateEventRequest(req);

  await timer_service.resumeTimer(time: time, userId: user.id!);

  return res.message('Timer resumed');
}

Future<Response> skipBlock(Request req) async {
  final user = getUserOrThrow(req);
  final time = await validateEventRequest(req);

  await timer_service.skipBlock(userId: user.id!, time: time);

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
      .post('/skip', skipBlock);
}
