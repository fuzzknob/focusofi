import '../models/timer.dart';
import 'repository.dart';

class TimerRepository extends Repository<Timer> {
  @override
  String get table => 'timers';

  Future<Timer> create({
    required DateTime startTime,
    required DateTime timerStartedAt,
    required TimerStatus status,
    required int successionCount,
    required int elapsedPrePause,
    required int workTillStatusChange,
    required int breakTillStatusChange,
    required int userId,
  }) async {
    return save(
      Timer(
        startTime: startTime,
        timerStartedAt: timerStartedAt,
        status: status,
        successionCount: successionCount,
        elapsedPrePause: elapsedPrePause,
        workTillStatusChange: workTillStatusChange,
        breakTillStatusChange: breakTillStatusChange,
        userId: userId,
      ),
    );
  }

  @override
  Timer mapToModel(Map<String, Object?> map) {
    return Timer(
      id: map['id'] as int,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int),
      timerStartedAt: DateTime.fromMillisecondsSinceEpoch(
        map['timer_started_at'] as int,
      ),
      status: TimerStatus.fromString(map['status'] as String),
      successionCount: map['session_count'] as int,
      elapsedPrePause: map['elapsed_pre_pause'] as int,
      breakTillStatusChange: map['break_till_status_change'] as int,
      workTillStatusChange: map['work_till_status_change'] as int,
      userId: map['user_id'] as int,
    );
  }

  @override
  Map<String, Object?> modelToMap(Timer model) {
    return {
      'start_time': model.startTime.millisecondsSinceEpoch,
      'timer_started_at': model.timerStartedAt.millisecondsSinceEpoch,
      'status': model.status.value,
      'session_count': model.successionCount,
      'elapsed_pre_pause': model.elapsedPrePause,
      'break_till_status_change': model.breakTillStatusChange,
      'work_till_status_change': model.workTillStatusChange,
      'user_id': model.userId,
    };
  }
}
