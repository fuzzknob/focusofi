import 'dart:async';
import 'dart:convert';

import 'event.dart';
import 'broadcastable.dart';

abstract interface class Broadcaster {
  void broadcast(String event, String payload);

  void listen(void Function(String event, String? payload) listener);
}

class EventBus {
  final broadcasters = <Broadcaster>[];
  final eventInitializers =
      <String, Event Function(Map<String, Object?> json)>{};

  final controller = StreamController<Event>.broadcast();

  StreamSubscription<Event> listen<T extends Event>(void Function(T) listener) {
    return controller.stream.listen((event) {
      if (event is T) {
        listener(event);
      }
    });
  }

  void plugBroadcaster(Broadcaster broadcaster) {
    broadcaster.listen(listenBroadcast);
    broadcasters.add(broadcaster);
  }

  void listenBroadcast(String event, String? payload) {
    final eventInitializer = eventInitializers[event];
    if (eventInitializer == null) return;

    controller.add(
      eventInitializer(payload != null ? json.decode(payload) : {}),
    );
  }

  void registerEventInitializer<T extends Event>(
    String eventName,
    T Function(Map<String, Object?> json) fromJson,
  ) {
    eventInitializers[eventName] = fromJson;
  }

  dispatch(Event event) {
    if (event is Broadcastable) {
      final broadcastable = event as Broadcastable;

      for (final broadcaster in broadcasters) {
        broadcaster.broadcast(
          broadcastable.eventName,
          broadcastable.serialize(),
        );
      }
    } else {
      controller.add(event);
    }
  }
}

final eventBus = EventBus();
