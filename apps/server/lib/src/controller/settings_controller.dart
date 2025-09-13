import 'package:lucore/lucore.dart';
import 'package:acanthis/acanthis.dart' as acanthis;

import '../libs/utils.dart';
import '../middlewares/auth_middlwares.dart';
import '../services/settings_service.dart' as settings_service;

Future<Response> index(Request req) async {
  final user = getUserOrThrow(req);

  final settings = await user.settings();

  return res.json(settings?.toJson());
}

final updateSettingsSchema = acanthis.object({
  'workLength': acanthis.number().integer().gte(10).lte(3600),
  'shortBreakLength': acanthis.number().integer().gte(10).lte(3600),
  'longBreakLength': acanthis.number().integer().gte(10).lte(3600),
  'workSessions': acanthis.number().integer().gte(2).lte(10),
  'progressive': acanthis.boolean(),
});

Future<Response> update(Request req) async {
  final result = await validate(req, updateSettingsSchema);

  final user = getUserOrThrow(req);

  await settings_service.updateSettings(
    user.id!,
    workLength: result['workLength'],
    shortBreakLength: result['shortBreakLength'],
    longBreakLength: result['longBreakLength'],
    workSessions: result['workSessions'],
    progressive: result['progressive'],
  );

  return res.message('Successfully saved settings');
}

Router settingsRoutes() {
  final router = Router.nest('/settings', middlewares: [authGuard]);

  router.get('/', index);

  router.put('/', update);

  return router;
}
