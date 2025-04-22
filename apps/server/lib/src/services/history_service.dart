import '../models/history.dart';

Future<History> createHistory({
  required String name,
  required DateTime startTime,
  required DateTime endTime,
  required int totalWorkTime,
  required int totalBreakTime,
  required int userId,
}) {
  return History.db.create(
    name: name,
    startTime: startTime,
    endTime: endTime,
    totalWorkTime: totalWorkTime,
    totalBreakTime: totalBreakTime,
    userId: userId,
  );
}
