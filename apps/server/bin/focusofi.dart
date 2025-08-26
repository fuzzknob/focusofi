import 'dart:io';

import 'package:cli_util/cli_logging.dart';

import 'package:focusofi/server.dart';
import 'package:focusofi/database.dart';

void main(List<String> arguments) async {
  final command = arguments.firstOrNull;

  final logger = Logger.standard();

  if (command == null) {
    await serve();
  } else if (command == 'migrate') {
    await migrate();
  } else if (command == 'migrate-start') {
    await migrate();
    await serve();
  } else if (command == 'seed') {
    final seedName = arguments.elementAtOrNull(1);
    if (seedName == null) {
      logger.stderr('Invalid seed name!');
      exit(1);
    }
    await seed(seedName);
  } else {
    logger.stderr('Command not found!');
    exit(1);
  }
}
