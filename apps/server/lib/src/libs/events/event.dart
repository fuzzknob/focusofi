import 'event_bus.dart';

abstract class Event {
  const Event();

  void dispatch() {
    eventBus.dispatch(this);
  }
}
