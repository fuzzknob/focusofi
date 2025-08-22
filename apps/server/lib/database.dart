import 'src/database/migration.dart' as migration;
import 'src/database/seeders/seed_registry.dart';

Future<void> migrate() async {
  await migration.migrate();
  print('✅ Migration successful');
}

Future<void> seed(String seedName) async {
  final seed = seedRegistry[seedName];

  if (seed == null) {
    throw Exception('🚫 Seeder "$seedName" not found');
  }

  await seed.seed();

  print('✅ Seeding \'$seedName seeder\' successful');
}
