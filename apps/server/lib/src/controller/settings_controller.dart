import 'package:lucore/lucore.dart';

import '../libs/utils.dart';
import '../middlewares/auth_middlwares.dart';

Future<Response> index(Request req) async {
  final user = getUserOrThrow(req);

  final settings = await user.settings();

  return res.json(settings?.toJson());
}

Router settingsRoutes() {
  final router = Router.nest('/settings', middlewares: [authGuard]);

  router.get('/', index);

  return router;
}
