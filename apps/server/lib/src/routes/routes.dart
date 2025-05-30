import 'package:lucore/lucore.dart';

import '../controller/auth_controller.dart';
import '../controller/background_controller.dart';
import '../controller/settings_controller.dart';
import '../controller/timer_controller.dart';
import '../controller/events_controller.dart';

Router appRoutes() {
  final routes = Router();

  routes.get('/status', (_) => res.ok());

  routes.merge(authRoutes());
  routes.merge(backgroundRoutes());
  routes.merge(settingsRoutes());
  routes.merge(timerRoutes());
  routes.merge(eventRoutes());

  return routes;
}
