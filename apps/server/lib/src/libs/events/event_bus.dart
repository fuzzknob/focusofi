import 'dart:async';

import 'event.dart';

class EventBus {
  final controller = StreamController<Event>.broadcast();

  StreamSubscription<Event> listen<T extends Event>(void Function(T) listener) {
    return controller.stream.listen((event) {
      if (event is T) {
        listener(event);
      }
    });
  }

  dispatch(Event event) {
    controller.add(event);
  }
}

final eventBus = EventBus();
