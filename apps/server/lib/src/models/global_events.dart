import '../repositories/global_events_repository.dart';

import 'model.dart';

class GlobalEvents implements Model {
  GlobalEvents({this.id, required this.name, this.payload});

  @override
  int? id;
  String name;
  String? payload;

  static GlobalEventsRepository get db => GlobalEventsRepository();

  // The ! at the end is important or else it will delete every records
  Future<void> delete() => db.delete(id!);

  Future<void> save() => db.save(this);
}
