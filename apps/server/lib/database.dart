import 'dart:io';

import 'src/libs/utils.dart';
import 'src/database/database.dart';
import 'src/database/seeders/seed_registry.dart';

Future<void> migrate() async {
  final schemaPath = getEnvOrDefault('SCHEMA_PATH', 'db/schema.sql');

  final file = File(schemaPath);

  final schema = await file.readAsString();

  await database.executeRaw(schema);

  print('✅ Migration successful');
}

Future<void> seed(String seedName) async {
  final seed = seedRegistry[seedName];

  if (seed == null) {
    throw Exception('🚫 Seeder not $seedName found');
  }

  await seed.seed();

  print('✅ Seeding \'$seedName seeder\' successful');
}
