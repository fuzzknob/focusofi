import '../models/session.dart';

import 'repository.dart';

class SessionRepository extends Repository<Session> {
  @override
  String get table => 'sessions';

  Future<Session> create({
    required int userId,
    required String token,
    required DateTime expiration,
  }) async {
    return save(Session(userId: userId, token: token, expiration: expiration));
  }

  @override
  Session mapToModel(Map<String, Object?> map) {
    return Session(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      token: map['token'] as String,
      expiration: DateTime.fromMillisecondsSinceEpoch(map['expiration'] as int),
    );
  }

  @override
  Map<String, Object?> modelToMap(Session model) {
    return {
      'user_id': model.userId,
      'token': model.token,
      'expiration': model.expiration.millisecondsSinceEpoch,
    };
  }
}
