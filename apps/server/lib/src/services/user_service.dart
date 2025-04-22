import '../models/user.dart';

Future<User> createUser(
  String email, {
  bool hasVerified = false,
  Role role = Role.user,
}) {
  return User.db.create(email: email, hasVerified: hasVerified, role: role);
}
