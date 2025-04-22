import '../models/history.dart';

import 'repository.dart';

class HistoryRepository extends Repository<History> {
  @override
  String get table => 'histories';

  Future<History> create({
    required String name,
    required DateTime startTime,
    required DateTime endTime,
    required int totalWorkTime,
    required int totalBreakTime,
    required int userId,
  }) {
    return save(
      History(
        name: name,
        startTime: startTime,
        endTime: endTime,
        totalWorkTime: totalWorkTime,
        totalBreakTime: totalBreakTime,
        userId: userId,
      ),
    );
  }

  @override
  History mapToModel(Map<String, Object?> map) {
    return History(
      id: map['id'] as int,
      name: map['name'] as String?,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int),
      totalBreakTime: map['total_break_time'] as int,
      totalWorkTime: map['total_work_time'] as int,
      userId: map['user_id'] as int,
    );
  }

  @override
  Map<String, Object?> modelToMap(History model) {
    return {
      'name': model.name,
      'start_time': model.startTime.millisecondsSinceEpoch,
      'end_time': model.endTime.millisecondsSinceEpoch,
      'total_break_time': model.totalBreakTime,
      'total_work_time': model.totalWorkTime,
      'user_id': model.userId,
    };
  }
}
