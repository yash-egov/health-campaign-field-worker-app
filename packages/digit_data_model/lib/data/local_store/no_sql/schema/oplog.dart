import 'package:digit_data_model/data_model.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/models/entities/stock_reconciliation.dart';
import 'package:isar/isar.dart';
import '../../../../models/oplog/oplog_entry.dart';

part 'oplog.g.dart';

@Collection()
class OpLog {
  Id id = Isar.autoIncrement;
  late String entityString;

  @ignore
  getEntity<T extends EntityModel>() {
    switch (entityType.name) {
      // case "household":
      //   final entity = HouseholdModelMapper.fromJson(entityString);
      //   return entity;
      //
      // case "householdMember":
      //   final entity = HouseholdMemberModelMapper.fromJson(entityString);
      //   return entity;
      //
      // case "task":
      //   final entity = TaskModelMapper.fromJson(entityString);
      //   return entity;
      //
      // case "sideEffect":
      //   final entity = SideEffectModelMapper.fromJson(entityString);
      //   return entity;
      //
      // case "referral":
      //   final entity = ReferralModelMapper.fromJson(entityString);
      //   return entity;

      case "stock":
        final entity = StockModelMapper.fromJson(entityString);
        return entity;

      case "stockReconciliation":
        final entity = StockReconciliationModelMapper.fromJson(entityString);
        return entity;

      default:
        final entity = EntityModelMapper.fromJson(entityString);
        return entity;
    }
  }

  void entity<T extends EntityModel>(T entity) {
    entityString = entity.toJson();
  }

  @Enumerated(EnumType.name)
  late DataModelType entityType;

  @Enumerated(EnumType.name)
  late DataOperation operation;

  String? serverGeneratedId;

  String? clientReferenceId;

  DateTime? syncedUpOn;

  DateTime? syncedDownOn;

  late String createdBy;

  late DateTime createdAt;

  late bool syncedUp;

  late bool syncedDown;

  late List<AdditionalId> additionalIds;

  late int rowVersion;

  late int syncDownRetryCount;

  late bool nonRecoverableError;
}

@embedded
class AdditionalId {
  late String idType;
  late String id;
}
