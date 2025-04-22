import 'package:lucore/lucore.dart';
import 'package:acanthis/acanthis.dart' as acanthis;
import 'package:pomo_server/src/middlewares/auth_middlwares.dart';

import '../libs/utils.dart';
import '../services/auth_service.dart' as auth_service;

final requestLoginSchema = acanthis.object({
  'email': acanthis.string().email().required(),
});

Future<Response> requestLogin(Request req) async {
  final result = await validate(req, requestLoginSchema);

  final email = result['email'] as String;

  await auth_service.requestLogin(email);

  return res.message('Successfully request email');
}

final loginWithOtpSchema = acanthis
    .object({
      'otp': acanthis.string().length(5).required(),
      'mobile': acanthis.boolean(),
    })
    .optionals(['mobile']);

Future<Response> loginWithOtp(Request req) async {
  final result = await validate(req, loginWithOtpSchema);

  final otp = result['otp'] as String;
  final bool isMobile = result['mobile'] ?? false;

  final session = await auth_service.loginWithOtp(otp);

  if (isMobile) {
    return res.json({'token': session.token});
  }

  final hostUrl = getEnv('BASE_HOST_URL')!;

  return res
      .signedCookie(
        'authorization',
        'Bearer ${session.token}',
        expires: DateTime.now().add(Duration(days: 30)),
        domain: hostUrl,
        sameSite: SameSite.none,
      )
      .message('Successfully logged in');
}

Future<Response> logout(Request req) async {
  final token = await parseSessionToken(req);

  if (token == null) {
    return res.message('Already logged out');
  }

  await auth_service.logout(token);

  return res.removeCookie('authorization').message('Successfully logged out');
}

Future<Response> me(Request req) async {
  final user = getUserOrThrow(req);
  return res.json(user.toJson());
}

Router authRoutes() {
  final routes = Router.nest('/auth');

  routes.get('/me', me, middlewares: [authGuard]);
  routes.get('/logout', logout, middlewares: [authGuard]);
  routes.post('/request-login', requestLogin);
  routes.post('/login-with-otp', loginWithOtp);

  return routes;
}
