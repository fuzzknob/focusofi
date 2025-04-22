import '../models/background.dart';

Future<Background?> getRandomBackground() {
  return Background.db.random().first();
}

Future<List<Background>?> getAllBackgrounds() {
  return Background.db.orderBy('created_at', 'DESC').all();
}

Future<Background?> createBackground(String img) {
  return Background.db.create(img: img);
}

Future<void> deleteBackground(int id) {
  return Background.db.delete(id);
}
