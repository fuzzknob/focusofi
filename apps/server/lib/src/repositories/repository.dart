import 'package:luex/luex.dart';

import '../models/model.dart';
import '../database/database.dart';

abstract class Repository<T extends Model> {
  Repository() {
    qb = database.table(table);
  }

  late final QueryBuilder qb;

  String get table;

  Repository<T> where(String column, Object valueOrOperator, [Object? value]) {
    qb.where(column, valueOrOperator, value);
    return this;
  }

  Repository<T> orWhere(
    String column,
    Object valueOrOperator, [
    Object? value,
  ]) {
    qb.orWhere(column, valueOrOperator, value);
    return this;
  }

  Repository<T> orderBy(String column, [String direction = 'ASC']) {
    qb.orderBy(column, direction);
    return this;
  }

  Repository<T> random() {
    qb.random();
    return this;
  }

  Repository<T> limit(int limit) {
    qb.limit(limit);
    return this;
  }

  Future<List<T>?> all() => get();

  Future<List<T>?> get() async {
    final results = await qb.get();
    return results?.map((map) => mapToModel(map)).toList();
  }

  Future<T?> first() async {
    final result = await limit(1).get();
    return result?.firstOrNull;
  }

  Future<T?> find(int id) async {
    return where('id', id).first();
  }

  Future<T> save(T model) async {
    if (model.id == null) {
      final id = await insertGetId(model);
      model.id = id;
    } else {
      await where('id', model.id!).update(model);
    }
    return model;
  }

  Future<void> insert(T model) {
    final data = modelToMap(model);
    return qb.insert(data);
  }

  Future<void> insertMany(List<T> models) {
    final data = models.map(modelToMap).toList();
    return qb.insertMany(data);
  }

  Future<int?> insertGetId(T model) async {
    final data = modelToMap(model);
    final id = await qb.insertGetId(data);
    return id as int?;
  }

  Future<void> update(T model) {
    final data = modelToMap(model);
    return qb.update({
      ...data,
      'updated_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });
  }

  Future<void> delete([int? id]) {
    if (id != null) {
      qb.where('id', id);
    }
    return qb.delete();
  }

  T mapToModel(Map<String, Object?> map);

  Map<String, Object?> modelToMap(T model);
}
