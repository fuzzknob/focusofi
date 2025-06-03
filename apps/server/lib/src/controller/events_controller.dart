import 'package:lucore/lucore.dart';

import '../libs/utils.dart';
import '../libs/events/event_bus.dart';

import '../events/timer_event.dart';
import '../events/settings_updated_event.dart';
import '../middlewares/auth_middlwares.dart';

Response events(Request req) {
  final user = getUserOrThrow(req);

  return res.streamEvent((stream) async {
    final timerEventSub = eventBus.listen<TimerEvent>((event) {
      if (user.id != event.userId) return;

      stream.sendJson(event.toJson(), event: 'timer-event');
    });

    final settingEventSub = eventBus.listen<SettingsUpdatedEvent>((event) {
      if (user.id != event.userId) return;

      stream.sendJson(event.toJson(), event: 'settings-updated-event');
    });

    stream.onClose(() async {
      timerEventSub.cancel();
      settingEventSub.cancel();
    });
  });
}

Router eventRoutes() {
  return Router().get('/events', events, middlewares: [authGuard]);
}
