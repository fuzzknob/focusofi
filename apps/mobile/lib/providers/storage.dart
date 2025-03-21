import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomo_mobile/libs/local_storage.dart';

final localStorageProvider = FutureProvider((ref) async {
  final storage = LocalStorage();
  await storage.init();
  return storage;
});
