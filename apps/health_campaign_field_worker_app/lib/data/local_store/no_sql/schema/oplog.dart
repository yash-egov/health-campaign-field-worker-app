import 'package:isar/isar.dart';

import '../../../../models/data_model.dart';

part 'oplog.g.dart';

@Collection()
class OpLog {
  Id id = Isar.autoIncrement;
  late String entityString;

  @ignore
  T getEntity<T extends EntityModel>() {
    final entityValue = Mapper.fromJson<T>(entityString);
    final entityMap = entityValue.toMap();
    entityMap.putIfAbsent(
      entityValue.remotePrimaryKey,
      () => serverGeneratedId,
    );

    return Mapper.fromMap<T>(entityMap);
  }

  void entity<T extends EntityModel>(T entity) {
    entityString = entity.toJson();
  }

  @Enumerated(EnumType.name)
  late DataModelType entityType;

  @Enumerated(EnumType.name)
  late DataOperation operation;

  late DateTime createdOn;

  String? serverGeneratedId;

  String? clientReferenceId;

  DateTime? upSyncedOn;

  DateTime? downSyncedOn;

  late String createdBy;

  late bool isSyncedDown;

  late bool isSyncedUp;
}
