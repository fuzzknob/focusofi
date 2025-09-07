import 'package:dartx/dartx.dart';
import 'package:lucore/lucore.dart';
import 'package:intl/intl.dart';

import '../models/timer.dart';
import '../models/settings.dart';
import '../events/timer_event.dart';

import 'settings_service.dart' as settings_service;
import 'history_service.dart' as history_service;

Future<Timer?> getTimer(int userId, {bool sync = true, DateTime? now}) async {
  final timer = await Timer.db.where('user_id', userId).first();

  if (timer == null) return null;

  if (!sync) {
    return timer;
  }

  if (timer.timerState != TimerState.running) return timer;

  final settings = await settings_service.getSettingsOrThrow(userId);

  final currentTimer = syncTimer(
    timer: timer.copyWith(),
    settings: settings,
    now: now,
  );

  await currentTimer.save();

  return currentTimer;
}

Future<Timer> startTimer({required DateTime time, required int userId}) async {
  var timer = await getTimer(userId, now: time);

  if (timer != null) {
    throw BadRequestException('Timer already started');
  }

  final settings = await settings_service.getSettingsOrThrow(userId);

  final sequence = generateSequence(settings, 1);

  sequence.startSequence(time);

  timer = await Timer.db.create(
    startedAt: time,
    userId: userId,
    currentSequence: sequence,
    timerState: TimerState.running,
    seqGenCount: 1,
    accumulatedBreak: 0,
    accumulatedWork: 0,
  );

  TimerEvent(
    action: TimerAction.start,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Future<Timer> stopTimer({required int userId, required DateTime time}) async {
  final timer = await getTimer(userId, now: time);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  timer.timerState = TimerState.stopped;

  await timer.save();

  await history_service.createHistory(
    name: '',
    startTime: timer.startedAt,
    endTime: time,
    totalBreakTime: timer.totalBreak,
    totalWorkTime: timer.totalWork,
    userId: userId,
  );

  TimerEvent(action: TimerAction.stop, userId: userId, timer: timer).dispatch();

  return timer;
}

Future<Timer> resetTimer({required int userId}) async {
  final timer = await getTimer(userId);

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

Future<Timer> pauseTimer({required int userId, required DateTime time}) async {
  final timer = await getTimer(userId, now: time);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  timer.timerState = TimerState.paused;

  await timer.save();

  TimerEvent(
    action: TimerAction.pause,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Future<Timer> resumeTimer({required DateTime time, required int userId}) async {
  final timer = await getTimer(userId);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  if (timer.timerState != TimerState.paused) {
    throw BadRequestException('Timer is not paused');
  }

  timer.timerState = TimerState.running;

  final block = timer.currentSequence.blocks.firstWhere(
    (block) => !block.completed,
  );

  block.startTime = time.subtract(Duration(seconds: block.elapsed));

  await timer.save();

  TimerEvent(
    action: TimerAction.resume,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Future<Timer> skipBlock({required DateTime time, required int userId}) async {
  final timer = await getTimer(userId, now: time);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  final currentBlock = timer.currentSequence.blocks.firstWhere(
    (block) => !block.completed,
  );

  currentBlock.completed = true;

  var nextBlock = timer.currentSequence.blocks.firstOrNullWhere(
    (block) => !block.completed,
  );

  // Is the last in the sequence block
  if (nextBlock == null) {
    final settings = await settings_service.getSettingsOrThrow(userId);

    timer.seqGenCount++;

    final newSequence = generateSequence(settings, timer.seqGenCount);

    timer.accumulatedBreak += timer.currentSequence.elapsedBreakLength;
    timer.accumulatedWork += timer.currentSequence.elapsedWorkLength;
    timer.currentSequence = newSequence;

    newSequence.startTime = time;

    nextBlock = newSequence.blocks.first;
  }

  nextBlock.startTime = time;

  timer.timerState = TimerState.running;

  await timer.save();

  TimerEvent(
    action: TimerAction.skipBlock,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

Future<Timer> extendBlock({
  required DateTime time,
  required int extendTime,
  required int userId,
}) async {
  final timer = await getTimer(userId, now: time);

  if (timer == null) {
    throw BadRequestException('There is no running timer');
  }

  final sequence = timer.currentSequence;

  final currentBlock = sequence.blocks.firstWhere((block) => !block.completed);

  currentBlock.length += extendTime;
  sequence.modified = true;

  await timer.save();

  TimerEvent(
    action: TimerAction.extendBlock,
    userId: userId,
    timer: timer,
  ).dispatch();

  return timer;
}

String formatPrint(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  return formatter.format(date);
}

Timer syncTimer({
  required Timer timer,
  required Settings settings,
  DateTime? now,
}) {
  now ??= DateTime.now();
  var sequence = timer.currentSequence;

  do {
    final endTime = sequence.endTime;

    if (endTime.isAfter(now)) {
      sequence.blocks = syncBlocks(sequence.blocks, now);
      timer.currentSequence = sequence;

      return timer;
    }

    timer.seqGenCount++;
    timer.accumulatedBreak += sequence.breakLength;
    timer.accumulatedWork += sequence.workLength;
    sequence = generateSequence(settings, timer.seqGenCount);

    sequence.startSequence(endTime);
  } while (sequence.modified);

  final totalPastTime = now.difference(sequence.startTime!);

  final sessionCount = (totalPastTime.inSeconds / sequence.totalLength).floor();

  if (sessionCount > 0) {
    timer.seqGenCount += sessionCount;
    timer.accumulatedBreak += sequence.breakLength * sessionCount;
    timer.accumulatedWork += sequence.workLength * sessionCount;

    final startTime = sequence.startTime!.add(
      Duration(seconds: sequence.totalLength * sessionCount),
    );

    sequence = generateSequence(settings, timer.seqGenCount);

    sequence.startSequence(startTime);
  }

  sequence.blocks = syncBlocks(sequence.blocks, now);
  timer.currentSequence = sequence;

  return timer;
}

List<Block> syncBlocks(List<Block> blocks, DateTime now) {
  DateTime? lastBlockEndTime;

  for (final block in blocks) {
    final startTime = block.startTime ?? lastBlockEndTime!;

    if (startTime.isAfter(now)) {
      throw Exception('Block starts after "now"');
    }

    block.startTime = startTime;

    final blockEndTime = startTime.add(Duration(seconds: block.length));

    lastBlockEndTime = blockEndTime;

    // Just so we don't overwrite skipped block's elapsed time
    if (block.completed) {
      continue;
    }

    if (blockEndTime.isBefore(now)) {
      block.completed = true;
      block.elapsed = block.length;

      continue;
    }

    // Copying frontend
    block.elapsed = (now.difference(startTime).inMilliseconds / 1000).round();

    return blocks;
  }

  throw Exception('Blocks out of range');
}

Sequence generateSequence(Settings settings, int seqGenCount) {
  final blocks = <Block>[];

  if (settings.progressive && seqGenCount == 1) {
    return progressiveSequence;
  }

  for (var i = 1; i <= settings.workSessions; i++) {
    blocks.add(
      Block(
        type: BlockType.work,
        length: settings.workLength,
        elapsed: 0,
        completed: false,
      ),
    );

    if (i < settings.workSessions) {
      blocks.add(
        Block(
          type: BlockType.shortBreak,
          length: settings.shortBreakLength,
          elapsed: 0,
          completed: false,
        ),
      );
      continue;
    }

    blocks.add(
      Block(
        type: BlockType.longBreak,
        length: settings.longBreakLength,
        elapsed: 0,
        completed: false,
      ),
    );
  }

  return Sequence(blocks: blocks);
}

final progressiveSequence = Sequence(
  blocks: [
    Block(type: BlockType.work, length: 300),
    Block(type: BlockType.shortBreak, length: 300),
    Block(type: BlockType.work, length: 600),
    Block(type: BlockType.shortBreak, length: 300),
    Block(type: BlockType.work, length: 900),
    Block(type: BlockType.shortBreak, length: 300),
    Block(type: BlockType.work, length: 1200),
    Block(type: BlockType.shortBreak, length: 300),
    Block(type: BlockType.work, length: 1500),
    Block(type: BlockType.longBreak, length: 900),
  ],
  modified: true,
);
