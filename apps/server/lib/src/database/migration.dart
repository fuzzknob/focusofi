import 'dart:io';
import 'package:dartx/dartx_io.dart';
import '../libs/utils.dart';

import 'database.dart';

Future<void> setupMigration() async {
  await database.executeRaw('''
    PRAGMA foreign_keys = ON;

    PRAGMA journal_mode = WAL;

    PRAGMA wal_autocheckpoint = 1000;

    CREATE TABLE IF NOT EXISTS `migrations` (
        `id` integer PRIMARY KEY NOT NULL,
        `name` text NOT NULL,
        `applied_at` integer DEFAULT (unixepoch ()) NOT NULL
    );
  ''');
}

Future<List<String>> getAppliedMigrations() async {
  final entries = await database.table('migrations').all();

  if (entries == null) {
    return [];
  }

  return entries.map((entry) => entry['name']).whereType<String>().toList();
}

Future<void> markMigrationAsApplied(String name) {
  return database.table('migrations').insert({'name': name});
}

Future<void> migrate() async {
  final migrationPath = getEnvOrDefault('MIGRATION_PATH', 'db/migrations');
  final migrationDir = Directory(migrationPath);

  if (!await migrationDir.exists()) {
    print('$migrationPath doesn\'t exist!');
    return;
  }

  await setupMigration();

  final migrations =
      await migrationDir.list(followLinks: false, recursive: false).toList();

  migrations.sort((a, b) => a.path.compareTo(b.path));

  final appliedMigrations = await getAppliedMigrations();

  for (final migration in migrations) {
    // if it's not a file
    if (migration is! File) {
      continue;
    }

    final migrationName = migration.nameWithoutExtension;

    if (appliedMigrations.contains(migrationName)) {
      continue;
    }

    final rawSql = await migration.readAsString();

    await database.executeRaw(rawSql);

    await markMigrationAsApplied(migrationName);
  }
}
