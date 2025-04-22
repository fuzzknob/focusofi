import 'package:luex/luex.dart';

import '../libs/utils.dart';

Database? _db;

Database get database {
  if (_db == null) {
    final path = getEnv('DATABASE_PATH', required: true)!;
    _db = Database.init(SqliteConnection.file(path, runInIsolate: false));
  }
  return _db!;
}
