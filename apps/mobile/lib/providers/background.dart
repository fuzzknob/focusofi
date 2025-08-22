import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomo_mobile/services/background_service.dart';

final backgroundProvider = StateProvider<String>((_) => '');

final getBackgroundServiceProvider = Provider((ref) {
  return () async {
    final bg = await fetchBackground();
    ref.read(backgroundProvider.notifier).state = bg;
  };
});
