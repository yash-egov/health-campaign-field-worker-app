import 'package:dart_mappable/dart_mappable.dart';

import '../data_model.dart';

@MappableClass()
class OpLogEntry<T extends EntityModel> {
  final int? id;
  final T entity;
  final DataModelType type;
  final DataOperation operation;
  final bool isSyncedUp;
  final bool isSyncedDown;
  final DateTime dateCreated;
  final String createdBy;
  final DateTime? upSyncedOn;
  final DateTime? downSyncedOn;
  final String? serverGeneratedId;

  const OpLogEntry(
    this.entity,
    this.operation, {
    required this.createdBy,
    required this.type,
    required this.dateCreated,
    this.id,
    this.isSyncedUp = false,
    this.isSyncedDown = false,
    this.serverGeneratedId,
    this.upSyncedOn,
    this.downSyncedOn,
  });

  String? getEntityId([String key = 'id']) {
    final entityMap = entity.toMap();
    if (entityMap.containsKey(key)) {
      final entityId = entityMap[key];
      if (entityId is String) return entityId;
    }

    return null;
  }

  String? getEntityClientReferenceId([String? key = 'clientReferenceId']) {
    final entityMap = entity.toMap();
    if (entityMap.containsKey(key)) {
      final entityId = entityMap[key];
      if (entityId is String) return entityId;
    }

    return null;
  }
}

@MappableEnum()
enum DataOperation {
  create,
  search,
  update,
  delete,
  singleCreate,
}

@MappableEnum(caseStyle: CaseStyle.snakeCase)
enum ApiOperation {
  login,
  create,
  search,
  update,
  delete,
  bulkCreate,
  bulkUpdate,
  bulkDelete,
  singleCreate
}
