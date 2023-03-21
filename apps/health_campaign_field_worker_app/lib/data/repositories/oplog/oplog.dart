import 'dart:async';

import 'package:isar/isar.dart';

import '../../../models/data_model.dart';
import '../../local_store/no_sql/schema/oplog.dart';

abstract class OpLogManager<T extends EntityModel> {
  final Isar isar;

  const OpLogManager(this.isar);

  FutureOr<void> createEntry(
    OpLogEntry<T> entry,
    DataModelType type,
  ) async =>
      await isar.writeTxn(() async => await isar.opLogs.put(
            OpLog()
              ..operation = entry.operation
              ..isSynced = false
              ..entityType = type
              ..createdBy = entry.createdBy
              ..createdOn = entry.dateCreated
              ..clientReferenceId = entry.getEntityClientReferenceId(
                entry.entity.localPrimaryKey,
              )
              ..serverGeneratedId = entry.serverGeneratedId ??
                  entry.getEntityId(
                    entry.entity.remotePrimaryKey,
                  )
              ..syncedOn = entry.syncedOn
              ..entityString = entry.entity.toJson(),
          ));

  FutureOr<List<OpLogEntry<T>>> getPendingSyncedEntries(
    DataModelType type, {
    required String createdBy,
  }) async {
    final createdEntries = await isar.opLogs
        .filter()
        .operationEqualTo(DataOperation.create)
        .createdByEqualTo(createdBy)
        .entityTypeEqualTo(type)
        .findAll();

    final updateEntries = await isar.opLogs
        .filter()
        .serverGeneratedIdIsNotNull()
        .operationEqualTo(DataOperation.update)
        .isSyncedEqualTo(false)
        .createdByEqualTo(createdBy)
        .entityTypeEqualTo(type)
        .findAll();

    final deleteEntries = await isar.opLogs
        .filter()
        .serverGeneratedIdIsNotNull()
        .operationEqualTo(DataOperation.delete)
        .isSyncedEqualTo(false)
        .createdByEqualTo(createdBy)
        .entityTypeEqualTo(type)
        .findAll();

    final entries = [
      createdEntries,
      updateEntries,
      deleteEntries,
    ].expand((element) => element);

    return entries
        .map((e) => OpLogEntry<T>(
              Mapper.fromJson<T>(e.entityString),
              e.operation,
              dateCreated: e.createdOn,
              id: e.id,
              syncedOn: e.syncedOn,
              serverGeneratedId: e.serverGeneratedId,
              createdBy: e.createdBy,
              type: e.entityType,
              isSynced: e.isSynced,
            ))
        .toList();
  }

  FutureOr<List<OpLogEntry<T>>> getSyncedCreateEntries(
    DataModelType type,
  ) async {
    final entries = await isar.opLogs
        .filter()
        .isSyncedEqualTo(true)
        .entityTypeEqualTo(type)
        .operationEqualTo(DataOperation.create)
        .findAll();

    return entries
        .map((e) => OpLogEntry<T>(
              Mapper.fromJson<T>(e.entityString),
              e.operation,
              dateCreated: e.createdOn,
              serverGeneratedId: e.serverGeneratedId,
              syncedOn: e.syncedOn,
              id: e.id,
              createdBy: e.createdBy,
              type: e.entityType,
              isSynced: e.isSynced,
            ))
        .where((element) => element.id != null)
        .toList();
  }

  Future<void> updateServerGeneratedIdInAllOplog(
    String? serverGeneratedId,
    String clientReferenceId,
  ) async {
    if (serverGeneratedId == null) return;

    await isar.writeTxn(() async {
      final opLogs = await isar.opLogs
          .filter()
          .clientReferenceIdEqualTo(clientReferenceId)
          .findAll();

      for (final oplog in opLogs) {
        await isar.opLogs.put(
          oplog..serverGeneratedId = serverGeneratedId,
        );
      }
    });
  }

  FutureOr<void> update(OpLogEntry<EntityModel> entry) async {
    final id = entry.id;
    if (id == null) return;
    await isar.writeTxn(() async {
      await isar.opLogs.put(
        OpLog()
          ..id = id
          ..operation = entry.operation
          ..isSynced = entry.isSynced
          ..entityType = entry.type
          ..clientReferenceId = entry.getEntityClientReferenceId(
            entry.entity.localPrimaryKey,
          )
          ..serverGeneratedId = entry.serverGeneratedId ??
              entry.getEntityId(
                entry.entity.remotePrimaryKey,
              )
          ..syncedOn = entry.syncedOn
          ..createdBy = entry.createdBy
          ..createdOn = entry.dateCreated
          ..syncedOn = entry.syncedOn
          ..entityString = entry.entity.toJson(),
      );
    });
  }
}

class IndividualOpLogManager extends OpLogManager<IndividualModel> {
  IndividualOpLogManager(super.isar);
}

class HouseholdOpLogManager extends OpLogManager<HouseholdModel> {
  HouseholdOpLogManager(super.isar);
}

class FacilityOpLogManager extends OpLogManager<FacilityModel> {
  FacilityOpLogManager(super.isar);
}

class HouseholdMemberOpLogManager extends OpLogManager<HouseholdMemberModel> {
  HouseholdMemberOpLogManager(super.isar);
}

class ProjectBeneficiaryOpLogManager
    extends OpLogManager<ProjectBeneficiaryModel> {
  ProjectBeneficiaryOpLogManager(super.isar);
}

class ProjectFacilityOpLogManager extends OpLogManager<ProjectFacilityModel> {
  ProjectFacilityOpLogManager(super.isar);
}

class TaskOpLogManager extends OpLogManager<TaskModel> {
  TaskOpLogManager(super.isar);
}

class ProjectStaffOpLogManager extends OpLogManager<ProjectStaffModel> {
  ProjectStaffOpLogManager(super.isar);
}

class ProjectOpLogManager extends OpLogManager<ProjectModel> {
  ProjectOpLogManager(super.isar);
}

class StockOpLogManager extends OpLogManager<StockModel> {
  StockOpLogManager(super.isar);
}

class StockReconciliationOpLogManager
    extends OpLogManager<StockReconciliationModel> {
  StockReconciliationOpLogManager(super.isar);
}

class ServiceDefinitionOpLogManager
    extends OpLogManager<ServiceDefinitionModel> {
  ServiceDefinitionOpLogManager(super.isar);
}

class ServiceOpLogManager extends OpLogManager<ServiceModel> {
  ServiceOpLogManager(super.isar);
}

class ProjectResourceOpLogManager extends OpLogManager<ProjectResourceModel> {
  ProjectResourceOpLogManager(super.isar);
}

class ProductVariantOpLogManager extends OpLogManager<ProductVariantModel> {
  ProductVariantOpLogManager(super.isar);
}

class BoundaryOpLogManager extends OpLogManager<BoundaryModel> {
  BoundaryOpLogManager(super.isar);
}
