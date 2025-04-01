import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum Role { user, admin }

@freezed
sealed class User with _$User {
  const factory User({required String email, required Role role}) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
