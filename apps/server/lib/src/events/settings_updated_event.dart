import '../libs/events/event.dart';
import '../models/settings.dart';
import '../models/timer.dart';

class SettingsUpdatedEvent extends Event {
  SettingsUpdatedEvent({
    required this.userId,
    required this.settings,
    this.timer,
  });

  final Settings settings;
  final int userId;
  final Timer? timer;

  Map<String, Object?> toJson() => {
    'settings': settings.toJson(),
    'userId': userId,
    'timer': timer?.toJson(),
  };
}
