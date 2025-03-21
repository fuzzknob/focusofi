import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomo_mobile/layers/initialization_layer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

import 'ui/app.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  KeepScreenOn.turnOn();
  runApp(const ProviderScope(child: InitializationLayer(child: PomoApp())));
}
