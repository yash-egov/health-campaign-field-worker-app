import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'local_store/sql_store/sql_store.dart';
import '../models/data_model.dart';

abstract class DataRepository<D extends DataModel, R extends DataModel> {
  FutureOr<List<D>> search(R query);

  FutureOr<dynamic> create(D entity);

  FutureOr<dynamic> update(D entity);
}

class RemoteRepository<D extends DataModel, R extends DataModel>
    extends DataRepository<D, R> {
  final Dio dio;
  final String path;
  final String entityName;

  RemoteRepository(
    this.dio, {
    required this.path,
    required this.entityName,
  });

  String get createPath => '$path/_create';

  String get updatePath => '$path/_update';

  String get searchPath => '$path/_search';

  @override
  FutureOr<List<D>> search(R query) async {
    final response = await dio.post(createPath, data: {
      entityName: query.toMap(),
    });

    final responseMap = json.decode(response.data);
    if (responseMap is! Map<String, dynamic>) {
      throw InvalidApiResponseException(
        data: query.toMap(),
        path: searchPath,
        response: responseMap,
      );
    }

    if (!responseMap.containsKey(entityName)) {
      throw InvalidApiResponseException(
        data: query.toMap(),
        path: searchPath,
        response: responseMap,
      );
    }

    final entityResponse = await responseMap[entityName];
    if (entityResponse is! List) {
      throw InvalidApiResponseException(
        data: query.toMap(),
        path: searchPath,
        response: responseMap,
      );
    }

    final entityList = entityResponse.whereType<Map<String, dynamic>>();

    return entityList.map((e) => Mapper.fromMap<D>(e)).toList();
  }

  @override
  FutureOr<Response> create(D entity) async {
    return await dio.post(
      createPath,
      data: {
        entityName: [entity.toMap()],
        "apiOperation": "CREATE",
      },
    );
  }

  @override
  FutureOr<Response> update(D entity) async {
    return await dio.post(
      updatePath,
      data: {
        entityName: [entity.toMap()],
        "apiOperation": "UPDATE",
      },
    );
  }
}

abstract class LocalRepository<D extends DataModel, R extends DataModel>
    extends DataRepository<D, R> {
  final LocalSqlDataStore sqlDataStore;
  final Isar isar;

  LocalRepository(this.sqlDataStore, this.isar);

  @override
  FutureOr<int> create(D entity);

  @override
  FutureOr<int> update(D entity);

  FutureOr<int> createOplogEntry(D entity, ApiOperation operation);

  FutureOr<void> deleteOplogEntry(OpLogEntry<D> entry);
}

class InvalidApiResponseException implements Exception {
  final String path;
  final Map<String, dynamic> data;
  final dynamic response;

  const InvalidApiResponseException({
    required this.path,
    required this.data,
    required this.response,
  });
}
