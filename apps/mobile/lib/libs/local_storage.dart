import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  late Box<dynamic> hiveBox;

  init() async {
    hiveBox = await Hive.openBox<dynamic>('POMO_BOX');
  }

  Future<T?> get<T>(String key) async {
    return hiveBox.get(key);
  }

  Future set<T>(String key, T data) async {
    await hiveBox.put(key, data);
  }

  Future delete(String key) async {
    await hiveBox.delete(key);
  }

  Future clear() async {
    await hiveBox.clear();
  }
}
