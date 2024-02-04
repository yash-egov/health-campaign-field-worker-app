import 'package:attendance_management/attendance_management.dart';
import 'package:dart_mappable/dart_mappable.dart';

import 'attendance_audit.dart';

@MappableClass()
class RegisterAuditDetails extends AttendanceAuditDetails {
  final String? registerId;

  const RegisterAuditDetails({
    required String createdBy,
    required int createdTime,
    String? lastModifiedBy,
    int? lastModifiedTime,
    this.registerId,
  }) : super(
          createdBy: createdBy,
          createdTime: createdTime,
          lastModifiedBy: lastModifiedBy,
          lastModifiedTime: lastModifiedTime,
        );
}

@MappableClass(ignoreNull: true)
class AttendancePackageRegisterModel {
  static const schemaName = 'AttendanceRegister';

  final String id;
  final String? tenantId;
  final String? registerNumber;
  final String? name;
  final String? referenceId;
  final String? serviceCode;
  final String? status;
  final bool? nonRecoverableError;
  final int? rowVersion;
  final int? startDate;
  final int? endDate;
  final List<AttendeeModel>? attendees;
  final List<StaffModel>? staff;
  final Map<String, dynamic>? additionalDetails;
  final AttendanceAuditDetails? auditDetails;
  final int? completedDays;
  final List<Map<DateTime, bool>>? attendanceLog;

  AttendancePackageRegisterModel({
    this.additionalDetails,
    required this.id,
    this.tenantId,
    this.registerNumber,
    this.name,
    this.referenceId,
    this.serviceCode,
    this.status,
    this.nonRecoverableError = false,
    this.rowVersion,
    this.startDate,
    this.endDate,
    this.attendees,
    this.staff,
    this.auditDetails,
    this.completedDays = 0,
    this.attendanceLog = const [],
  }) : super();
}

@MappableClass(ignoreNull: true)
class AttendanceRegisterAdditionalFields {
  final Map<String, dynamic> description;
  AttendanceRegisterAdditionalFields({
    required this.description,
  });
}
