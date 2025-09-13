import 'dart:convert';

import '../models/timer.dart';
import 'repository.dart';

class TimerRepository extends Repository<Timer> {
  @override
  String get table => 'timers';

  Future<Timer> create({
    required DateTime startedAt,
    required TimerState timerState,
    required Sequence currentSequence,
    required int seqGenCount,
    required int accumulatedBreak,
    required int accumulatedWork,
    required int userId,
  }) async {
    return save(
      Timer(
        startedAt: startedAt,
        timerState: timerState,
        currentSequence: currentSequence,
        seqGenCount: seqGenCount,
        accumulatedBreak: accumulatedBreak,
        accumulatedWork: accumulatedWork,
        userId: userId,
      ),
    );
  }

  @override
  Timer mapToModel(Map<String, Object?> map) {
    return Timer(
      id: map['id'] as int,
      timerState: TimerState.fromString(map['timer_state'] as String),
      currentSequence: Sequence.fromJson(
        json.decode(map['current_sequence'] as String),
      ),
      seqGenCount: map['sequence_gen_count'] as int,
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['started_at'] as int),
      accumulatedBreak: map['accumulated_break'] as int,
      accumulatedWork: map['accumulated_work'] as int,
      userId: map['user_id'] as int,
    );
  }

  @override
  Map<String, Object?> modelToMap(Timer model) {
    return {
      'timer_state': model.timerState.value,
      'current_sequence': json.encode(model.currentSequence.toJson()),
      'sequence_gen_count': model.seqGenCount,
      'started_at': model.startedAt.millisecondsSinceEpoch,
      'accumulated_break': model.accumulatedBreak,
      'accumulated_work': model.accumulatedWork,
      'user_id': model.userId,
    };
  }
}
