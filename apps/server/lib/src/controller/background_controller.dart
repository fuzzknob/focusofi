import 'package:lucore/lucore.dart';
import 'package:acanthis/acanthis.dart' as acanthis;

import '../libs/utils.dart';
import '../middlewares/auth_middlwares.dart';
import '../middlewares/admin_guard.dart';
import '../services/background_service.dart' as background_service;

Future<Response> index(Request req) async {
  final background = await background_service.getRandomBackground();

  return res.json(background?.toJson());
}

Future<Response> all(Request req) async {
  final backgrounds = await background_service.getAllBackgrounds();

  return res.json(backgrounds?.map((b) => b.toJson(includeId: true)).toList());
}

final backgroundImgSchema = acanthis.object({
  'img': acanthis.string().url().transform((value) => value.trim()),
});

Future<Response> create(Request req) async {
  final result = await validate(req, backgroundImgSchema);

  final img = result['img'] as String;

  final background = await background_service.createBackground(img);

  return res.json(background?.toJson());
}

Future<Response> delete(Request req) async {
  final id = int.parse(req.parameters['id']!);

  await background_service.deleteBackground(id);

  return res.message('Background deleted successfully');
}

Router backgroundRoutes() {
  final routes = Router.nest('/background');

  routes.get('/', index);
  routes.get('/all', all, middlewares: [authGuard, adminGuard]);
  routes.post('/', create, middlewares: [authGuard, adminGuard]);
  routes.delete('/:id', delete, middlewares: [authGuard, adminGuard]);

  return routes;
}
