import '../models/email_otp.dart';

import 'repository.dart';

class EmailOtpRepository extends Repository<EmailOtp> {
  @override
  String get table => 'email_otps';

  Future<EmailOtp> create({
    required String otpCode,
    required int userId,
    required DateTime expiration,
  }) {
    return save(
      EmailOtp(otpCode: otpCode, userId: userId, expiration: expiration),
    );
  }

  @override
  EmailOtp mapToModel(Map<String, Object?> map) {
    return EmailOtp(
      id: map['id'] as int,
      otpCode: map['otp_code'] as String,
      userId: map['user_id'] as int,
      expiration: DateTime.fromMillisecondsSinceEpoch(map['expiration'] as int),
    );
  }

  @override
  Map<String, Object?> modelToMap(EmailOtp model) {
    return {
      'otp_code': model.otpCode,
      'user_id': model.userId,
      'expiration': model.expiration.millisecondsSinceEpoch,
    };
  }
}
