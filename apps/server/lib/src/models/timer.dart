import '../repositories/timer_repository.dart';

import 'model.dart';

class Timer implements Model {
  Timer({
    this.id,
    required this.timerState,
    required this.currentSequence,
    required this.seqGenCount,
    required this.startedAt,
    required this.accumulatedBreak,
    required this.accumulatedWork,
    required this.userId,
  });

  @override
  int? id;
  final DateTime startedAt;
  final int userId;
  TimerState timerState;
  Sequence currentSequence;
  int seqGenCount;
  int accumulatedBreak;
  int accumulatedWork;

  int get totalBreak => accumulatedBreak + currentSequence.elapsedBreakLength;

  int get totalWork => accumulatedWork + currentSequence.elapsedWorkLength;

  static TimerRepository get db => TimerRepository();

  Future<void> delete() => db.delete(id!);

  Future<Timer> save() => db.save(this);

  Timer copyWith({
    int? id,
    DateTime? startedAt,
    TimerState? timerState,
    Sequence? currentSequence,
    int? seqGenCount,
    int? accumulatedBreak,
    int? accumulatedWork,
    int? userId,
  }) => Timer(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    timerState: timerState ?? this.timerState,
    currentSequence: currentSequence ?? this.currentSequence,
    seqGenCount: seqGenCount ?? this.seqGenCount,
    accumulatedBreak: accumulatedBreak ?? this.accumulatedBreak,
    accumulatedWork: accumulatedWork ?? this.accumulatedWork,
    userId: userId ?? this.userId,
  );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'startedAt': startedAt.toUtc().toIso8601String(),
      'timerState': timerState.value,
      'currentSequence': currentSequence.toJson(),
      'seqGenCount': seqGenCount,
      'accumulatedBreak': accumulatedBreak,
      'accumulatedWork': accumulatedWork,
      'userId': userId,
    };
  }

  factory Timer.fromJson(Map<String, Object?> json) {
    return Timer(
      id: json['id'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      timerState: TimerState.fromString(json['timerState'] as String),
      currentSequence: Sequence.fromJson(
        json['currentSequence'] as Map<String, Object?>,
      ),
      seqGenCount: json['seqGenCount'] as int,
      accumulatedBreak: json['accumulatedBreak'] as int,
      accumulatedWork: json['accumulatedWork'] as int,
      userId: json['userId'] as int,
    );
  }
}

enum TimerStatus {
  idle,
  working,
  shortBreak,
  longBreak,
  paused,
  stopped;

  String get value {
    return switch (this) {
      (TimerStatus.idle) => 'IDLE',
      (TimerStatus.working) => 'WORKING',
      (TimerStatus.shortBreak) => 'SHORT_BREAK',
      (TimerStatus.longBreak) => 'LONG_BREAK',
      (TimerStatus.paused) => 'PAUSED',
      (TimerStatus.stopped) => 'STOPPED',
    };
  }

  @override
  String toString() => value;

  static TimerStatus fromString(String status) {
    return switch (status) {
      ('IDLE') => TimerStatus.idle,
      ('WORKING') => TimerStatus.working,
      ('SHORT_BREAK') => TimerStatus.shortBreak,
      ('LONG_BREAK') => TimerStatus.longBreak,
      ('PAUSED') => TimerStatus.paused,
      ('STOPPED') => TimerStatus.stopped,
      _ => throw Exception('$status is not a valid timer status'),
    };
  }
}

enum TimerState {
  idle,
  running,
  paused,
  stopped;

  String get value {
    return switch (this) {
      (TimerState.idle) => 'IDLE',
      (TimerState.running) => 'RUNNING',
      (TimerState.paused) => 'PAUSED',
      (TimerState.stopped) => 'STOPPED',
    };
  }

  @override
  String toString() => value;

  static TimerState fromString(String state) {
    return switch (state) {
      ('IDLE') => TimerState.idle,
      ('RUNNING') => TimerState.running,
      ('PAUSED') => TimerState.paused,
      ('STOPPED') => TimerState.stopped,
      _ => throw Exception('$state is not valid timer state'),
    };
  }
}

class Sequence {
  Sequence({required this.blocks, this.modified = false, this.startTime});

  List<Block> blocks;
  bool modified;
  DateTime? startTime;

  int get totalLength => _calculateTotalLength(blocks);

  int get workLength => _calculateTotalLength(
    blocks.where((block) => block.type == BlockType.work),
  );

  int get breakLength => _calculateTotalLength(
    blocks.where(
      (block) =>
          [BlockType.longBreak, BlockType.shortBreak].contains(block.type),
    ),
  );

  int get elapsedWorkLength =>
      _calculateElapsed(blocks.where((block) => block.type == BlockType.work));

  int get elapsedBreakLength => _calculateElapsed(
    blocks.where(
      (block) =>
          block.completed &&
          [BlockType.longBreak, BlockType.shortBreak].contains(block.type),
    ),
  );

  int _calculateTotalLength(Iterable<Block> blocks) {
    return blocks.fold(
      0,
      (previous, block) =>
          previous + (block.completed ? block.elapsed : block.length),
    );
  }

  int _calculateElapsed(Iterable<Block> blocks) {
    return blocks.fold(0, (previous, block) => previous + block.elapsed);
  }

  DateTime get endTime {
    DateTime? currentBlockStartTime;
    int remainingLength = 0;

    for (final block in blocks) {
      if (block.completed) {
        continue;
      }

      // The first completed block is the current block
      currentBlockStartTime ??= block.startTime;

      remainingLength += block.length;
    }

    return currentBlockStartTime!.add(Duration(seconds: remainingLength));
  }

  factory Sequence.fromJson(Map<String, Object?> json) {
    return Sequence(
      blocks:
          (json['blocks'] as List)
              .map((block) => Block.fromJson(block))
              .toList(),
      modified: json['modified'] as bool,
      startTime:
          json['startTime'] != null
              ? DateTime.parse(json['startTime'] as String)
              : null,
    );
  }

  void startSequence(DateTime time) {
    blocks[0].startTime = time;
    startTime = time;
  }

  Map<String, Object?> toJson() {
    return {
      'modified': modified,
      'startTime': startTime?.toUtc().toIso8601String(),
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }
}

class Block {
  Block({
    required this.type,
    required this.length,
    this.completed = false,
    this.elapsed = 0,
    this.startTime,
  });

  final BlockType type;
  int length;
  int elapsed;
  bool completed;
  DateTime? startTime;

  factory Block.fromJson(Map<String, Object?> json) {
    return Block(
      type: BlockType.fromString(json['type'] as String),
      length: json['length'] as int,
      completed: json['completed'] as bool,
      elapsed: json['elapsed'] as int? ?? 0,
      startTime:
          json['startTime'] != null
              ? DateTime.parse(json['startTime'] as String)
              : null,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'type': type.value,
      'length': length,
      'completed': completed,
      'elapsed': elapsed,
      'startTime': startTime?.toUtc().toIso8601String(),
    };
  }
}

enum BlockType {
  work,
  shortBreak,
  longBreak;

  String get value {
    return switch (this) {
      (BlockType.work) => 'WORK',
      (BlockType.shortBreak) => 'SHORT_BREAK',
      (BlockType.longBreak) => 'LONG_BREAK',
    };
  }

  @override
  String toString() => value;

  static BlockType fromString(String type) {
    return switch (type) {
      ('WORK') => BlockType.work,
      ('SHORT_BREAK') => BlockType.shortBreak,
      ('LONG_BREAK') => BlockType.longBreak,
      _ => throw Exception('$type '),
    };
  }
}
