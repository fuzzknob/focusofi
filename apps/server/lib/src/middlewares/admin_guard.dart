import 'package:lucore/lucore.dart';

import '../libs/utils.dart';
import '../models/user.dart';

FutureOr<Response> adminGuard(Request req, Next next) async {
  final user = getUserOrThrow(req);
  if (user.role != Role.admin) {
    return res.unauthorized().message(
      'You don\'t have permission for this action',
    );
  }
  return next();
}
