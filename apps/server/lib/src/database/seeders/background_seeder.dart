import 'dart:io';
import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:pomo_server/src/models/background.dart';
import 'package:pomo_server/src/libs/utils.dart';

import 'seeder.dart';

class BackgroundSeeder implements Seeder {
  const BackgroundSeeder();

  @override
  Future<void> seed() async {
    final assetPath = getEnv('SEED_ASSETS_PATH', required: true)!;
    final file = File('$assetPath/backgrounds.json');
    final json = await file.readAsString();
    final backgrounds = jsonDecode(json) as List;

    for (final chunk in backgrounds.chunked(100)) {
      await Background.db.insertMany(
        chunk.map((img) => Background(img: img as String)).toList(),
      );
    }
  }
}
