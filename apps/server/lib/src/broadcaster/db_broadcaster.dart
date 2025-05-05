import 'dart:async';

import '../libs/events/event_bus.dart';
import '../models/global_events.dart';

class DbBroadcaster implements Broadcaster {
  final listeners = <void Function(String event, String? payload)>[];
  int? lastEventId;

  void init() async {
    GlobalEvents? event =
        await GlobalEvents.db.orderBy('created_at', 'DESC').first();
    lastEventId = event?.id;
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      event = await GlobalEvents.db.orderBy('created_at', 'DESC').first();

      if (event == null) continue;

      if (lastEventId == event.id) continue;

      for (final listener in listeners) {
        listener(event.name, event.payload);
      }

      lastEventId = event.id;
    }
  }

  @override
  void broadcast(String event, String payload) {
    GlobalEvents.db.create(name: event, payload: payload);
  }

  @override
  void listen(void Function(String event, String? payload) listener) {
    listeners.add(listener);
  }
}
