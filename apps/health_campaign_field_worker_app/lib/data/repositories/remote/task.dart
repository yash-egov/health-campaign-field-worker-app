// Generated using mason. Do not modify by hand

import '../../../models/data_model.dart';
import '../../data_repository.dart';

class TaskRemoteRepository extends RemoteRepository<TaskModel, TaskSearchModel> {
  TaskRemoteRepository(
    super.dio, {
    required super.searchPath,
    required super.createPath,
    required super.updatePath,
    super.entityName = 'Task',
  });

  @override
  DataModelType get type => DataModelType.task;
}
