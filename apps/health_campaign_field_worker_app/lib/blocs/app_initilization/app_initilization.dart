import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import '../../data/local_store/no_sql/schema/app_configuration.dart';

import '../../data/local_store/no_sql/schema/service_registry.dart';
import '../../data/repositories/remote/mdms.dart';
import '../../models/app_config/app_config_model.dart' as app_configuration;
import '../../data/repositories/remote/mdms.dart';
import '../../models/mdms/service_registry/service_registry_model.dart';
import '../../utils/constants.dart';

part 'app_initilization.freezed.dart';

typedef AppInitilizationEmitter = Emitter<AppInitilizationState>;

class AppInitilizationBloc
    extends Bloc<AppInitilizationEvent, AppInitilizationState> {
  final MdmsRepository mdmsRepository;
  final Isar isar;
  AppInitilizationBloc(
    AppInitilizationState appInitilizationState, {
    required this.mdmsRepository,
    required this.isar,
  }) : super(const AppInitilizationState()) {
    on<AppInitilizationSetupEvent>(_onAppInitilizeSetup);
    on<FindAppConfigurationEvent>(_onAppConfigurationSetup);
  }

  FutureOr<void> _onAppInitilizeSetup(
    AppInitilizationSetupEvent event,
    AppInitilizationEmitter emit,
  ) async {
    ServiceRegistryPrimaryWrapperModel result =
        await mdmsRepository.searchServiceRegistry(
      Constants.mdmsApiPath,
      {
        "MdmsCriteria": {
          "tenantId": "default",
          "moduleDetails": [
            {
              "moduleName": "HCM-SERVICE-REGISTRY",
              "masterDetails": [
                {
                  "name": "serviceRegistry",
                },
              ],
            },
          ],
        },
      },
    );

    final List<ServiceRegistry> newServiceRegistryList = [];

    result.serviceRegitry?.serviceRegistrylist?.forEach((element) {
      final newServiceRegistry = ServiceRegistry();
      newServiceRegistry.service = element.service;
      final List<Actions>? actions = element.actions?.map((element) {
        final newServiceRegistryAction = Actions()
          ..create = element.create
          ..update = element.update
          ..login = element.login
          ..search = element.search;

        return newServiceRegistryAction;
      }).toList();

      newServiceRegistry.actions = actions;
      newServiceRegistryList.add(newServiceRegistry);
    });

    await isar.writeTxn(() async {
      await isar.serviceRegistrys
          .putAll(newServiceRegistryList); // insert & update
    });
    List<ServiceRegistry> localizationList =
        await isar.serviceRegistrys.where().findAll();
    emit(state.copyWith(localizationList: localizationList));
  }

  FutureOr<void> _onAppConfigurationSetup(
    FindAppConfigurationEvent event,
    AppInitilizationEmitter emit,
  ) async {
    app_configuration.AppConfigPrimaryWrapperModel result =
        await mdmsRepository.searchAppConfig(
      Constants.mdmsApiPath,
      {
        "MdmsCriteria": {
          "tenantId": "default",
          "moduleDetails": [
            {
              "moduleName": "HCM-FIELD-APP-CONFIG",
              "masterDetails": [
                {
                  "name": "appConfig",
                },
              ],
            },
          ],
        },
      },
    );

    final appConfiguration = AppConiguration();
    result.appConfig?.appConfiglist?.forEach((element) {
      appConfiguration
        ..networkDetection = element.networkDetection
        ..persistenceMode = element.persistenceMode
        ..syncMethod = element.syncMethod
        ..syncTrigger = element.syncTrigger;

      final List<Languages> languageList = element.languages.map((element) {
        final languages = Languages()
          ..label = element.label
          ..value = element.value;

        return languages;
      }).toList();

      final List<LocalizationModules>? localizationModules =
          element.localizationModules?.map((element) {
        final localization = LocalizationModules()
          ..label = element.label
          ..value = element.value;

        return localization;
      }).toList();

      appConfiguration.localizationModules = localizationModules;
      appConfiguration.languages = languageList;
    });

    await isar.writeTxn(() async {
      await isar.appConigurations.putAll([appConfiguration]);
    });
  }
}

@freezed
class AppInitilizationEvent with _$AppInitilizationEvent {
  const factory AppInitilizationEvent.onSetup() = AppInitilizationSetupEvent;

  const factory AppInitilizationEvent.onApplicationConfigurationSetup({
    String? service,
    required String actionType,
  }) = FindAppConfigurationEvent;
}

@freezed
class AppInitilizationState with _$AppInitilizationState {
  const AppInitilizationState._();

  const factory AppInitilizationState({
    @Default(false) bool isInitilizationCompleted,
    @Default([]) List<ServiceRegistry> localizationList,
  }) = _AppInitilizationState;
}
