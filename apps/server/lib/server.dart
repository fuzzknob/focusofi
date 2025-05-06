import 'package:lucore/lucore.dart';

import 'src/libs/utils.dart';
// import 'src/libs/events/event_bus.dart';
// import 'src/broadcaster/db_broadcaster.dart';
import 'src/routes/routes.dart';
// import 'src/events/timer_event.dart';

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

  // final dbBroadcaster = DbBroadcaster();

  // dbBroadcaster.init();

  // eventBus.plugBroadcaster(dbBroadcaster);
  // eventBus.registerEventInitializer('timer-event', TimerEvent.fromJson);

  final router = appRoutes();

  final port = getEnvOrDefault('PORT', '8000');

  server.serve(router, port: int.parse(port));
}
