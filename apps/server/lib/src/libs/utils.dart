import 'package:lucore/lucore.dart';
import 'package:dotenv/dotenv.dart';
import 'package:acanthis/acanthis.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

final _env = DotEnv(includePlatformEnvironment: true, quiet: true)
  ..load(['apps/server/.env']);

String? getEnv(String name, {bool required = false}) {
  final value = _env[name];
  if (required && value == null) {
    throw Exception('$name env variable is not set');
  }
  return _env[name];
}

String getEnvOrDefault(String name, String defaultValue) {
  final value = getEnv(name);
  return value ?? defaultValue;
}

String generateRandomString([int size = 32]) {
  if (size > 32) {
    throw LunartException(
      message: 'Random string size cannot be greater than 32',
    );
  }
  final uuid = Uuid().v4().replaceAll('-', '');
  return uuid.substring(0, size);
}

Future<Map<String, dynamic>> validate(
  Request req,
  AcanthisMap<dynamic> parser,
) async {
  final body = await req.body();
  if (body == null) {
    throw BadRequestException('Invalid Request!');
  }
  try {
    final result = parser.tryParse(body);

    if (!result.success) {
      print(result.errors);
      throw BadRequestException('Invalid request', result.errors);
    }

    return result.value;
  } on BadRequestException {
    rethrow;
  } catch (e) {
    throw BadRequestException('Invalid request', e);
  }
}

User getUserOrThrow(Request req) {
  final user = req.context['user'];
  if (user == null) {
    throw LunartException(statusCode: 401, message: 'User not found');
  }
  return user;
}

Future<String?> parseSessionToken(Request req) async {
  var authorization = await req.getSignedCookie('authorization');

  authorization ??= req.headers['authorization']?.join('');

  if (authorization == null) return null;

  return authorization.replaceFirst('Bearer ', '');
}
