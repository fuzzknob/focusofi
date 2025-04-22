import '../models/background.dart';

import 'repository.dart';

class BackgroundRepository extends Repository<Background> {
  @override
  String get table => 'backgrounds';

  Future<Background> create({required String img}) async {
    return save(Background(img: img));
  }

  @override
  Background mapToModel(Map<String, Object?> map) {
    return Background(id: map['id'] as int, img: map['img'] as String);
  }

  @override
  Map<String, Object?> modelToMap(Background model) {
    return {'img': model.img};
  }
}
