import 'package:dio/dio.dart';
import 'package:pomo_mobile/models/timer/timer.dart';

class TimerService {
  const TimerService({required this.request});
  final Dio request;

  Future<Timer?> fetchTimer() async {
    final res = await request.get('/timer');
    if (res.data == null) return null;
    return Timer.fromJson(res.data);
  }
}
