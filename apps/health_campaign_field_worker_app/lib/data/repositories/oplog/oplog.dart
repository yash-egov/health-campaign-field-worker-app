import 'dart:async';

import 'package:digit_components/digit_components.dart';
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
              ..isSyncedUp = false
              ..isSyncedDown = false
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
              ..upSyncedOn = entry.upSyncedOn
              ..downSyncedOn = entry.downSyncedOn
              ..entityString = entry.entity.toJson(),
          ));

  FutureOr<Iterable<OpLogEntry<T>>> getEntriesForUpSync(
    DataModelType type, {
    required String createdBy,
  }) async {
    final createdEntries = await isar.opLogs
        .filter()
        .operationEqualTo(DataOperation.create)
        .createdByEqualTo(createdBy)
        .entityTypeEqualTo(type)
        .isSyncedUpEqualTo(false)
        .findAll();

    final updateEntries = await isar.opLogs
        .filter()
        .operationEqualTo(DataOperation.update)
        .createdByEqualTo(createdBy)
        .serverGeneratedIdIsNotNull()
        .entityTypeEqualTo(type)
        .isSyncedUpEqualTo(false)
        .findAll();

    final deleteEntries = await isar.opLogs
        .filter()
        .operationEqualTo(DataOperation.delete)
        .createdByEqualTo(createdBy)
        .serverGeneratedIdIsNotNull()
        .entityTypeEqualTo(type)
        .isSyncedUpEqualTo(false)
        .findAll();

    final entries = [
      createdEntries,
      updateEntries,
      deleteEntries,
    ].expand((element) => element);

    return _getEntries(entries);
  }

  FutureOr<Iterable<OpLogEntry<T>>> getEntriesForDownSync(
    DataModelType type, {
    required String createdBy,
  }) async {
    final createdEntries = await isar.opLogs
        .filter()
        .operationEqualTo(DataOperation.create)
        .createdByEqualTo(createdBy)
        .entityTypeEqualTo(type)
        .isSyncedDownEqualTo(false)
        .findAll();

    final updateEntries = await isar.opLogs
        .filter()
        .operationEqualTo(DataOperation.update)
        .createdByEqualTo(createdBy)
        .entityTypeEqualTo(type)
        .isSyncedDownEqualTo(false)
        .findAll();

    final deleteEntries = await isar.opLogs
        .filter()
        .operationEqualTo(DataOperation.delete)
        .createdByEqualTo(createdBy)
        .entityTypeEqualTo(type)
        .isSyncedDownEqualTo(false)
        .findAll();

    final entries = [
      createdEntries,
      updateEntries,
      deleteEntries,
    ].expand((element) => element);

    return _getEntries(entries);
  }

  Iterable<OpLogEntry<T>> _getEntries(Iterable<OpLog> entries) => entries.map(
        (e) => OpLogEntry<T>(
          Mapper.fromJson<T>(e.entityString),
          e.operation,
          dateCreated: e.createdOn,
          id: e.id,
          serverGeneratedId: e.serverGeneratedId,
          createdBy: e.createdBy,
          type: e.entityType,
          downSyncedOn: e.downSyncedOn,
          upSyncedOn: e.upSyncedOn,
          isSyncedDown: e.isSyncedDown,
          isSyncedUp: e.isSyncedUp,
        ),
      );

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
        final entity = oplog.getEntity<T>();
        final entityMap = entity.toMap();

        entityMap.putIfAbsent(
          entity.remotePrimaryKey,
          () => serverGeneratedId,
        );

        await isar.opLogs.put(
          oplog..serverGeneratedId = serverGeneratedId,
        );
      }
    });
  }

  FutureOr<void> update(OpLogEntry<EntityModel> entry) async {
    final id = entry.id;
    if (id == null) return;

    AppLogger.instance.info(
      entry.entity.toJson(),
      title: entry.type.name.toUpperCase(),
    );

    await isar.writeTxn(() async {
      await isar.opLogs.put(
        OpLog()
          ..id = id
          ..operation = entry.operation
          ..isSyncedDown = entry.isSyncedDown
          ..isSyncedUp = entry.isSyncedUp
          ..entityType = entry.type
          ..clientReferenceId = entry.getEntityClientReferenceId(
            entry.entity.localPrimaryKey,
          )
          ..serverGeneratedId = entry.serverGeneratedId ??
              entry.getEntityId(
                entry.entity.remotePrimaryKey,
              )
          ..createdBy = entry.createdBy
          ..createdOn = entry.dateCreated
          ..upSyncedOn = entry.upSyncedOn
          ..downSyncedOn = entry.downSyncedOn
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
