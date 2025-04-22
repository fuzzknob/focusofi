import 'package:lucore/lucore.dart';

import 'src/libs/utils.dart';
import 'src/routes/routes.dart';

Future<void> serve() async {
  final server = Server();

  server.use(logger);

  final frontEndURL = getEnv('FRONT_END_URL', required: true)!;

  server.use(
    cors(
      origins: [frontEndURL],
      credentials: true,
      allowMethods: [Method.get, Method.post, Method.put, Method.delete],
    ),
  );

  server.use(signedCookie(secret: getEnv('COOKIE_SECRET', required: true)!));

  final router = appRoutes();

  final port = getEnvOrDefault('PORT', '8000');

  server.serve(router, port: int.parse(port));
}
