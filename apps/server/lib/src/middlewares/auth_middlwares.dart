import 'package:lucore/lucore.dart';

import '../libs/utils.dart';
import '../services/auth_service.dart' as auth_service;

FutureOr<Response> authGuard(Request req, Next next) async {
  final token = await parseSessionToken(req);

  if (token == null) {
    return res.unauthorized().message('Unauthorized');
  }

  final user = await auth_service.validateToken(token);

  req.context['user'] = user;

  return next();
}
