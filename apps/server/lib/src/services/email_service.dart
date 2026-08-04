import 'resend_service.dart' as resend_service;
import '../libs/utils.dart';

Future<void> sendOtpEmail(
  String email, {
  required String otp,
}) async {
  final adminEmails = getEnv('ADMIN_EMAILS', required: true)!;
  final adminEmailList = adminEmails.split(',');

  if (!adminEmailList.contains(email)) {
    print(otp);

    return;
  }

  return resend_service.sendEmail(
    to: email,
    templateId: 'focusofi-login',
    context: {
      'login_code': otp,
      'expiration_minutes': '10',
    },
  );
}
