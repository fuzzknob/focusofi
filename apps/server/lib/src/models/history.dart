import '../repositories/history_repository.dart';

import 'model.dart';

class History implements Model {
  History({
    this.id,
    this.name,
    required this.startTime,
    required this.endTime,
    required this.totalWorkTime,
    required this.totalBreakTime,
    required this.userId,
  });

  @override
  int? id;

  String? name;
  DateTime startTime;
  DateTime endTime;
  int totalWorkTime;
  int totalBreakTime;
  int userId;

  static HistoryRepository get db => HistoryRepository();

  // The ! at the end is important or else it will delete every records
  Future<void> delete() => db.delete(id!);

  Future<void> save() => db.save(this);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'totalWorkTime': totalWorkTime,
      'totalBreakTime': totalBreakTime,
      'userId': userId,
    };
  }
}
