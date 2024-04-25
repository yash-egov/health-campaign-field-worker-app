import 'dart:async';

import 'package:digit_data_model/data_model.dart';
import 'package:digit_data_model/models/oplog/oplog_entry.dart';
import 'package:drift/drift.dart';

import '../../../models/data_model.dart';
import '../../../models/entities/project_facility.dart';
import '../../../utils/utils.dart';
import '../../data_repository.dart';
import '../../local_store/sql_store/sql_store.dart';

class ProjectFacilityLocalRepository
    extends LocalRepository<ProjectFacilityModel, ProjectFacilitySearchModel> {
  ProjectFacilityLocalRepository(super.sql, super.opLogManager);

  @override
  FutureOr<List<ProjectFacilityModel>> search(
    ProjectFacilitySearchModel query, [
    String? userId,
  ]) async {
    final selectQuery = sql.select(sql.projectFacility).join([]);

    final results = await (selectQuery
          ..where(
            buildAnd(
              [
                if (query.projectId != null)
                  sql.projectFacility.projectId.isIn(query.projectId!),
                if (query.facilityId != null)
                  sql.projectFacility.facilityId.isIn(query.facilityId!),
              ],
            ),
          ))
        .get();

    return results.map((e) {
      final projectFacility = e.readTable(sql.projectFacility);

      return ProjectFacilityModel(
        facilityId: projectFacility.facilityId,
        projectId: projectFacility.projectId,
        tenantId: projectFacility.tenantId,
        rowVersion: projectFacility.rowVersion,
        id: projectFacility.id,
        isDeleted: projectFacility.isDeleted,
      );
    }).toList();
  }

  @override
  FutureOr<void> create(
    ProjectFacilityModel entity, {
    bool createOpLog = false,
    DataOperation dataOperation = DataOperation.create,
  }) async {
    await sql.batch((batch) async {
      batch.insert(
        sql.projectFacility,
        entity.companion,
        mode: InsertMode.insertOrReplace,
      );
    });

    await super.create(
      entity,
      createOpLog: createOpLog,
    );
  }

  @override
  FutureOr<void> bulkCreate(
    List<ProjectFacilityModel> entities,
  ) async {
    final projectFacilityCompanions = entities.map((e) => e.companion).toList();

    await sql.batch((batch) async {
      batch.insertAll(
        sql.projectFacility,
        projectFacilityCompanions,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  DataModelType get type => DataModelType.projectFacility;
}
