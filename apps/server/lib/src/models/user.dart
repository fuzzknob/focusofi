import '../repositories/user_repository.dart';

import 'timer.dart';
import 'settings.dart';
import 'model.dart';

class User implements Model {
  User({
    this.id,
    required this.email,
    required this.role,
    required this.hasVerified,
  });

  @override
  int? id;
  String email;
  Role role;
  bool hasVerified;

  static UserRepository get db => UserRepository();

  Future<Settings?> settings() => Settings.db.where('user_id', id!).first();

  Future<Timer?> timer() => Timer.db.where('user_id', id!).first();

  Map<String, Object?> toJson() {
    return {'email': email, 'role': role.value, 'hasVerified': hasVerified};
  }

  // The ! at the end is important or else it will delete every records
  Future<void> delete() => db.delete(id!);

  Future<void> save() => db.save(this);
}

enum Role {
  user,
  admin;

  String get value {
    return switch (this) {
      (Role.user) => 'USER',
      (Role.admin) => 'ADMIN',
    };
  }

  @override
  String toString() => value;

  static Role fromString(String role) {
    return switch (role) {
      ('ADMIN') => Role.admin,
      ('USER') => Role.user,
      _ => throw Exception('$role is not a valid role'),
    };
  }
}
