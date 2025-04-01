import 'package:dio/dio.dart';
import 'package:pomo_mobile/models/settings/settings.dart';

class SettingsService {
  const SettingsService({required this.request});
  final Dio request;

  Future<Settings?> getSettings() async {
    final res = await request.get('/settings');
    if (res.data == null) return null;
    return Settings.fromJson(res.data);
  }
}
