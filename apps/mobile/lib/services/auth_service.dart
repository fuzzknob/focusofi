import 'package:pomo_mobile/libs/request.dart';

Future<void> requestLogin(String email) async {
  final request = requestFactory();
  await request.post('/auth/request-login', data: {'email': email});
}

Future<String?> loginWithOtp(String otp) async {
  final request = requestFactory();
  final res = await request.post<Map<String, dynamic>>(
    '/auth/login-with-otp',
    data: {'otp': otp, 'mobile': true},
  );
  return res.data!['token'];
}
