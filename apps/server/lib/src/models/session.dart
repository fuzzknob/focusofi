import '../repositories/session_repository.dart';

import 'user.dart';
import 'model.dart';

class Session implements Model {
  Session({
    this.id,
    required this.token,
    required this.expiration,
    required this.userId,
  });

  @override
  int? id;
  String token;
  int userId;
  DateTime expiration;

  static SessionRepository get db => SessionRepository();

  Future<User?> user() => User.db.find(userId);

  // The ! at the end is important or else it will delete every records
  Future<void> delete() => db.delete(id!);

  Future<void> save() => db.save(this);
}
