import 'package:lucore/lucore.dart';

import '../models/user.dart';
import '../models/email_otp.dart';
import '../models/session.dart';

import '../libs/utils.dart';

import 'user_service.dart' as user_service;
import 'settings_service.dart' as settings_service;

Future<EmailOtp> createEmailOtp(
  int userId, {
  DateTime? expiration,
  String? otp,
}) {
  final otpCode = otp ?? generateRandomString(5).toUpperCase();

  return EmailOtp.db.create(
    userId: userId,
    otpCode: otpCode,
    expiration: expiration ?? DateTime.now().add(Duration(minutes: 10)),
  );
}

Future<Session> createSession(
  int userId, {
  String? token,
  DateTime? expiration,
}) {
  return Session.db.create(
    userId: userId,
    token: token ?? generateRandomString(),
    // 3 months
    expiration: expiration ?? DateTime.now().add(Duration(days: 30 * 3)),
  );
}

Future<void> requestLogin(String email) async {
  var user = await User.db.where('email', email).first();

  user ??= await user_service.createUser(email);

  final emailOtp = await createEmailOtp(user.id!);

  // TODO: send the otp code to the user
  print(emailOtp.otpCode);
}

Future<Session> loginWithOtp(String otpCode) async {
  final emailOtp = await EmailOtp.db.where('otp_code', otpCode).first();

  await emailOtp?.delete();

  if (emailOtp == null || emailOtp.expiration.isBefore(DateTime.now())) {
    throw BadRequestException('Invalid otp token');
  }

  final user = await emailOtp.user();

  if (user == null) {
    throw LunartException(
      message: 'Data inconsistency',
      error: 'User with id ${emailOtp.userId} not found!',
    );
  }

  if (!user.hasVerified) {
    await settings_service.createSettings(user.id!);
    user.hasVerified = true;
    await user.save();
  }

  return createSession(user.id!);
}

Future<void> logout(String token) async {
  await Session.db.where('token', token).delete();
}

Future<User> validateToken(String token) async {
  final session = await Session.db.where('token', token).first();

  if (session == null || session.expiration.isBefore(DateTime.now())) {
    throw BadRequestException('Invalid session token');
  }

  final user = await session.user();

  if (user == null) {
    throw LunartException(
      message: 'Data inconsistency',
      error: 'User with id ${session.userId} not found!',
    );
  }

  return user;
}
