import '../models/global_events.dart';

import 'repository.dart';

class GlobalEventsRepository extends Repository<GlobalEvents> {
  @override
  String get table => 'global_events';

  Future<GlobalEvents> create({required String name, String? payload}) {
    return save(GlobalEvents(name: name, payload: payload));
  }

  @override
  GlobalEvents mapToModel(Map<String, Object?> map) {
    return GlobalEvents(
      id: map['id'] as int,
      name: map['name'] as String,
      payload: map['payload'] as String?,
    );
  }

  @override
  Map<String, Object?> modelToMap(GlobalEvents model) {
    return {'name': model.name, 'payload': model.payload};
  }
}
