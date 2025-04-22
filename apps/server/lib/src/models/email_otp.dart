import '../repositories/email_otp_repository.dart';

import 'user.dart';
import 'model.dart';

class EmailOtp implements Model {
  EmailOtp({
    this.id,
    required this.otpCode,
    required this.expiration,
    required this.userId,
  });

  @override
  int? id;
  String otpCode;
  DateTime expiration;
  int userId;

  static EmailOtpRepository get db => EmailOtpRepository();

  // one to one relation
  Future<User?> user() => User.db.find(userId);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'otpCode': otpCode,
      'expiration': expiration.toUtc().toIso8601String(),
    };
  }

  // The ! at the end is important or else it will delete every records
  Future<void> delete() => db.delete(id!);

  Future<void> save() => db.save(this);
}
