import '../repositories/background_repository.dart';

import 'model.dart';

class Background implements Model {
  Background({this.id, required this.img});

  @override
  int? id;

  String img;

  static BackgroundRepository get db => BackgroundRepository();

  // The ! at the end is important or else it will delete every records
  Future<void> delete() => db.delete(id!);

  Future<void> save() => db.save(this);

  Map<String, dynamic> toJson({bool includeId = false}) {
    return {if (includeId) 'id': id, 'img': img};
  }
}
