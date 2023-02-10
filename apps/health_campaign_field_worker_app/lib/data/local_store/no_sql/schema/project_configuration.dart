import 'package:isar/isar.dart';

@Collection()
class ProjectConfiguration {
  Id id = Isar.autoIncrement;

  @Name("tenantId")
  late String? tenantId;

  @Name("moduleName")
  late String? moduleName;

  @Name("projectTypes")
  late List<Projects>? projectTypes;
}

@embedded
class Projects {
  late String id;
  late String name;
  late String code;
  late String group;
  late String beneficiaryType;
  late List<String> eligibilityCriteria;
  late List<String> taskProcedure;
  late List<Resources> resources;
}

@embedded
class Resources {
  late String productVariantId;
  late bool isBaseUnitVariant;
}
