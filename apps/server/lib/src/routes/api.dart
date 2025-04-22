import 'package:lucore/lucore.dart';

import '../controller/auth_controller.dart';
import '../controller/background_controller.dart';
import '../controller/settings_controller.dart';
import '../controller/timer_controller.dart';

Router apiRoutes() {
  final routes = Router.nest('/api');

  routes.merge(authRoutes());
  routes.merge(backgroundRoutes());
  routes.merge(settingsRoutes());
  routes.merge(timerRoutes());

  return routes;
}
