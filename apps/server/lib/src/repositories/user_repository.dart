import '../models/user.dart';

import 'repository.dart';

class UserRepository extends Repository<User> {
  @override
  String get table => 'users';

  Future<User> create({
    required String email,
    required Role role,
    required bool hasVerified,
  }) {
    return save(User(email: email, role: role, hasVerified: hasVerified));
  }

  @override
  User mapToModel(Map<String, Object?> map) {
    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      hasVerified: map['has_verified'] != 0,
      role: Role.fromString(map['role'] as String),
    );
  }

  @override
  Map<String, Object?> modelToMap(User user) {
    return {
      'email': user.email,
      'role': user.role.value,
      'has_verified': user.hasVerified,
    };
  }
}
