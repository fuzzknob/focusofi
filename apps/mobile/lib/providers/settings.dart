import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomo_mobile/models/settings/settings.dart';
import 'package:pomo_mobile/providers/auth.dart';
import 'package:pomo_mobile/services/settings_service.dart';

final settingsProvider = StateProvider<Settings?>((ref) => null);

final settingsServiceProvider = Provider((ref) {
  final request = ref.watch(authRequestProvider);
  if (request == null) return null;
  return SettingsService(request: request);
});

final getSettingsProvider = Provider((ref) {
  return () async {
    final settingsService = ref.read(settingsServiceProvider);
    if (settingsService == null) return null;
    final settings = await settingsService.getSettings();
    ref.read(settingsProvider.notifier).state = settings;
  };
});
