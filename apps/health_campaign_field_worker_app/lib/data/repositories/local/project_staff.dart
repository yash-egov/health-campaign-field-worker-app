import 'dart:async';

import 'package:digit_data_model/data_model.dart';
import 'package:digit_data_model/models/oplog/oplog_entry.dart';
import 'package:drift/drift.dart';

import '../../../models/data_model.dart';
import '../../../models/entities/project_staff.dart';
import '../../../utils/utils.dart';
import '../../data_repository.dart';
import '../../local_store/sql_store/sql_store.dart';

class ProjectStaffLocalRepository
    extends LocalRepository<ProjectStaffModel, ProjectStaffSearchModel> {
  ProjectStaffLocalRepository(super.sql, super.opLogManager);

  @override
  FutureOr<void> create(
    ProjectStaffModel entity, {
    bool createOpLog = false,
    DataOperation dataOperation = DataOperation.create,
  }) async {
    final companion = entity.companion;
    try {
      await sql.batch((batch) {
        batch.insert(
          sql.projectStaff,
          companion,
          mode: InsertMode.insertOrReplace,
        );
      });

      await super.create(
        entity,
        createOpLog: createOpLog,
      );
    } catch (e) {
      print('Error creating project staff table: $e');
    }
  }

  @override
  FutureOr<List<ProjectStaffModel>> search(
    ProjectStaffSearchModel query, [
    String? userId,
  ]) async {
    final selectQuery = sql.select(sql.projectStaff).join([]);
    final results = await (selectQuery
          ..where(buildAnd([
            if (query.id != null)
              sql.projectStaff.id.equals(
                query.id!,
              ),
          ])))
        .get();

    return results.map((e) {
      final data = e.readTable(sql.projectStaff);

      return ProjectStaffModel(
        id: data.id,
        tenantId: data.tenantId,
        rowVersion: data.rowVersion,
        projectId: data.projectId,
        channel: data.channel,
        endDate: data.endDate,
        isDeleted: data.isDeleted,
        staffId: data.staffId,
        startDate: data.startDate,
        userId: data.userId,
      );
    }).toList();
  }

  @override
  DataModelType get type => DataModelType.projectStaff;
}
