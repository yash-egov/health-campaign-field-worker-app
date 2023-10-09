library app_utils;

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digit_components/theme/digit_theme.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:uuid/uuid.dart';

import '../blocs/search_households/search_households.dart';
import '../data/local_store/secure_store/secure_store.dart';
import '../models/data_model.dart';
import '../models/project_type/project_type_model.dart';

export 'app_exception.dart';
export 'constants.dart';
export 'extensions/extensions.dart';

Expression<bool> buildAnd(Iterable<Expression<bool?>> iterable) {
  if (iterable.isEmpty) return const Constant(true);
  final result = iterable.reduce((value, element) => value & element);

  return result.equals(true);
}

Expression<bool> buildOr(Iterable<Expression<bool?>> iterable) {
  if (iterable.isEmpty) return const Constant(true);
  final result = iterable.reduce((value, element) => value | element);

  return result.equals(true);
}

class IdGen {
  static const IdGen _instance = IdGen._internal();

  static IdGen get instance => _instance;

  /// Shorthand for [instance]
  static IdGen get i => instance;

  final Uuid uuid;

  const IdGen._internal() : uuid = const Uuid();

  String get identifier => uuid.v1();
}

class CustomValidator {
  /// Validates that control's value must be `true`
  static Map<String, dynamic>? requiredMin(AbstractControl<dynamic> control) {
    return control.value == null || control.value.toString().length >= 2
        ? null
        : {'Min2 characters Required': true};
  }

  static Map<String, dynamic>? validMobileNumber(
    AbstractControl<dynamic> control,
  ) {
    if (control.value == null || control.value.toString().isEmpty) {
      return null;
    }

    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';

    if (RegExp(pattern).hasMatch(control.value.toString())) return null;

    if (control.value.toString().length < 10) return {'mobileNumber': true};

    return {'mobileNumber': true};
  }

  static Map<String, dynamic>? validStockCount(
    AbstractControl<dynamic> control,
  ) {
    if (control.value == null || control.value.toString().isEmpty) {
      return {'required': true};
    }

    var parsed = int.tryParse(control.value) ?? 0;
    if (parsed < 0) {
      return {'min': true};
    } else if (parsed > 10000) {
      return {'max': true};
    }

    return null;
  }
}

setBgRunning(bool isBgRunning) async {
  final localSecureStore = LocalSecureStore.instance;
  await localSecureStore.setBackgroundService(isBgRunning);
}

performBackgroundService({
  BuildContext? context,
  required bool stopService,
  required bool isBackground,
}) async {
  final connectivityResult = await (Connectivity().checkConnectivity());

  final isOnline = connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.mobile;
  final service = FlutterBackgroundService();
  var isRunning = await service.isRunning();

  if (stopService) {
    if (isRunning) {
      if (!isBackground && context != null) {
        if (context.mounted) {
          DigitToast.show(
            context,
            options: DigitToastOptions(
              'Background Service Stopped',
              true,
              DigitTheme.instance.mobileTheme,
            ),
          );
        }
      }
    }
  } else {
    if (!isRunning && isOnline) {
      service.startService();
      if (context != null) {
        DigitToast.show(
          context!,
          options: DigitToastOptions(
            'Background Service stated',
            false,
            DigitTheme.instance.mobileTheme,
          ),
        );
      }
    }
  }
}

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate(this.latitude, this.longitude);
}

double calculateDistance(Coordinate start, Coordinate end) {
  const double earthRadius = 6371.0; // Earth's radius in kilometers

  double toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  double lat1Rad = toRadians(start.latitude);
  double lon1Rad = toRadians(start.longitude);
  double lat2Rad = toRadians(end.latitude);
  double lon2Rad = toRadians(end.longitude);

  double dLat = lat2Rad - lat1Rad;
  double dLon = lon2Rad - lon1Rad;

  double a = pow(sin(dLat / 2), 2) +
      cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;

  return distance;
}

Timer makePeriodicTimer(
  Duration duration,
  void Function(Timer timer) callback, {
  bool fireNow = false,
}) {
  var timer = Timer.periodic(duration, callback);
  if (fireNow) {
    callback(timer);
  }

  return timer;
}

final requestData = {
  "data": [
    {
      "id": 1,
      "name": "John Doe",
      "age": 30,
      "email": "johndoe@example.com",
      "address": {
        "street": "123 Main Street",
        "city": "New York",
        "state": "NY",
        "zipcode": "10001",
      },
      "orders": [
        {
          "id": 101,
          "product": "Widget A",
          "quantity": 2,
          "price": 10.99,
        },
        {
          "id": 102,
          "product": "Widget B",
          "quantity": 1,
          "price": 19.99,
        },
      ],
    },
    {
      "id": 2,
      "name": "Jane Smith",
      "age": 25,
      "email": "janesmith@example.com",
      "address": {
        "street": "456 Elm Street",
        "city": "Los Angeles",
        "state": "CA",
        "zipcode": "90001",
      },
      "orders": [
        {
          "id": 201,
          "product": "Widget C",
          "quantity": 3,
          "price": 15.99,
        },
        {
          "id": 202,
          "product": "Widget D",
          "quantity": 2,
          "price": 12.99,
        },
      ],
    },
    // ... Repeat the above structure to reach approximately 100KB in size
  ],
};

/// This checks for if the active cycle is a new cycle or its the past cycle,
/// If the active cycle is same as past cycle then all validations for tracking delivery applies, else validations do not get applied
bool checkEligibilityForActiveCycle(
  int activeCycle,
  HouseholdMemberWrapper householdWrapper,
) {
  final pastCycle = (householdWrapper.tasks ?? []).isNotEmpty
      ? householdWrapper.tasks?.last.additionalFields?.fields
              .firstWhereOrNull((e) => e.key == 'CycleIndex')
              ?.value ??
          '1'
      : '1';

  return (activeCycle == int.parse(pastCycle));
}

/*Check for if the individual falls on the valid age category*/
///  * Returns [true] if the individual is in the same cycle and is eligible for the next dose,
bool checkEligibilityForAgeAndAdverseEvent(
  DigitDOBAge age,
  ProjectType? projectType,
  TaskModel? tasks,
  List<AdverseEventModel>? adverseEvents,
) {
  int totalAgeMonths = age.years * 12 + age.months;
  final currentCycle = projectType?.cycles?.firstWhereOrNull(
    (e) =>
        (e.startDate!) < DateTime.now().millisecondsSinceEpoch &&
        (e.endDate!) > DateTime.now().millisecondsSinceEpoch,
    // Return null when no matching cycle is found
  );
  if (currentCycle != null &&
      currentCycle.startDate != null &&
      currentCycle.endDate != null) {
    bool recordedAdverseEvent = false;
    if ((tasks != null) && adverseEvents != null && adverseEvents.isNotEmpty) {
      final lastTaskTime =
          tasks.clientReferenceId == adverseEvents.last.taskClientReferenceId
              ? tasks.clientAuditDetails?.createdTime
              : null;
      recordedAdverseEvent = lastTaskTime != null &&
          (lastTaskTime >= currentCycle.startDate! &&
              lastTaskTime <= currentCycle.endDate!);

      return projectType?.validMinAge != null &&
              projectType?.validMaxAge != null
          ? totalAgeMonths >= projectType!.validMinAge! &&
                  totalAgeMonths <= projectType.validMaxAge!
              ? recordedAdverseEvent
                  ? false
                  : true
              : false
          : false;
    } else {
      return totalAgeMonths >= projectType!.validMinAge! &&
              totalAgeMonths <= projectType.validMaxAge!
          ? true
          : false;
    }
  }

  return false;
}

bool checkIfBeneficiaryRefused(
  List<TaskModel>? tasks,
) {
  final isBeneficiaryRefused = (tasks != null &&
      (tasks ?? []).isNotEmpty &&
      tasks.last.status == Status.beneficiaryRefused.toValue());

  return isBeneficiaryRefused;
}

bool checkStatus(
  List<TaskModel>? tasks,
  Cycle? currentCycle,
) {
  if (currentCycle != null &&
      currentCycle.startDate != null &&
      currentCycle.endDate != null) {
    if (tasks != null && tasks.isNotEmpty) {
      final lastTask = tasks.last;
      final lastTaskCreatedTime = lastTask.clientAuditDetails?.createdTime;
      // final lastDose = lastTask.additionalFields?.fields.where((e) => e.key = AdditionalFieldsType.doseIndex)
      if (lastTaskCreatedTime != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(lastTaskCreatedTime);
        final diff = DateTime.now().difference(date);
        final isLastCycleRunning =
            lastTaskCreatedTime >= currentCycle.startDate! &&
                lastTaskCreatedTime <= currentCycle.endDate!;

        return isLastCycleRunning
            ? lastTask.status == Status.partiallyDelivered.name
                ? true
                : diff.inHours >= 24
                    ? true
                    : false
            : true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}

bool recordedAdverseEvent(
  Cycle? selectedCycle,
  TaskModel? task,
  List<AdverseEventModel>? adverseEvents,
) {
  if (selectedCycle != null &&
      selectedCycle.startDate != null &&
      selectedCycle.endDate != null) {
    if ((task != null) && (adverseEvents ?? []).isNotEmpty) {
      final lastTaskCreatedTime =
          task.clientReferenceId == adverseEvents?.last.taskClientReferenceId
              ? task.clientAuditDetails?.createdTime
              : null;

      return lastTaskCreatedTime != null &&
          lastTaskCreatedTime >= selectedCycle.startDate! &&
          lastTaskCreatedTime <= selectedCycle.endDate!;
    }
  }

  return false;
}

bool allDosesDelivered(
  List<TaskModel>? tasks,
  Cycle? selectedCycle,
  List<AdverseEventModel>? adverseEvents,
  IndividualModel? individualModel,
) {
  if (selectedCycle == null ||
      selectedCycle.id == 0 ||
      (fetchDeliveries(selectedCycle.deliveries, individualModel) ?? [])
          .isEmpty) {
    return true;
  } else {
    if ((tasks ?? []).isNotEmpty) {
      final lastCycle = int.tryParse(tasks?.last.additionalFields?.fields
          .where(
            (e) => e.key == AdditionalFieldsType.cycleIndex.toValue(),
          )
          .first
          .value);
      final lastDose = int.tryParse(tasks?.last.additionalFields?.fields
          .where(
            (e) => e.key == AdditionalFieldsType.doseIndex.toValue(),
          )
          .first
          .value);
      if (lastDose != null &&
          lastDose ==
              fetchDeliveries(selectedCycle.deliveries, individualModel)
                  ?.length &&
          lastCycle != null &&
          lastCycle == selectedCycle.id &&
          tasks?.last.status != Status.partiallyDelivered.toValue()) {
        return true;
      } else if (selectedCycle.id == lastCycle &&
          tasks?.last.status == Status.partiallyDelivered.toValue()) {
        return false;
      } else if ((adverseEvents ?? []).isNotEmpty) {
        return recordedAdverseEvent(selectedCycle, tasks?.last, adverseEvents);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

List<DeliveryModel>? fetchDeliveries(
  List<DeliveryModel>? deliveries,
  IndividualModel? individualModel,
) {
  if (deliveries != null && individualModel != null) {
    final individualAge = DigitDateUtils.calculateAge(
      DigitDateUtils.getFormattedDateToDateTime(
            individualModel.dateOfBirth!,
          ) ??
          DateTime.now(),
    );
    final individualAgeInMonths =
        individualAge.years * 12 + individualAge.months;
    print('individualAgeInMonths');
    print(individualAgeInMonths);
    final filteredDeliveries = deliveries.where((delivery) {
      final condition = delivery.doseCriteria?.condition;
      if (condition != null) {
        //[TODO: Condition need to be handled in generic way,]
        final parts = condition.split('<=age<');
        final minCondition = int.tryParse(parts.first);
        final maxCondition = int.tryParse(parts.last);
        if (minCondition != null && maxCondition != null) {
          return individualAgeInMonths >= minCondition &&
              individualAgeInMonths <= maxCondition;
        }
      }

      return false;
    }).toList();

    return filteredDeliveries;
  }

  return [];
}
