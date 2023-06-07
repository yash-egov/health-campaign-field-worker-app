import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:recase/recase.dart';
import '../data/local_store/no_sql/schema/app_configuration.dart';
import '../data/local_store/no_sql/schema/localization.dart';
import '../data/local_store/no_sql/schema/oplog.dart';
import '../data/local_store/no_sql/schema/service_registry.dart';
import '../data/local_store/secure_store/secure_store.dart';
import '../data/local_store/sql_store/sql_store.dart';
import '../data/network_manager.dart';
import '../data/remote_client.dart';
import '../data/repositories/remote/bandwidth_check.dart';
import '../models/bandwidth/bandwidth_model.dart';
import '../models/data_model.dart';
import '../widgets/network_manager_provider_wrapper.dart';
import 'constants.dart';
import 'environment_config.dart';

late Isar _isar;
final LocalSqlDataStore _sql = LocalSqlDataStore();
late Dio _dio;
int i = 0;

Future<void> initializeService(_dio, _isar) async {
  print("----Main Method called---");
  final service = FlutterBackgroundService();
  _dio = _dio;
  _isar = _isar;

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'Background Sync', // title
    description: 'Background sync triggered.', // description
    importance: Importance.high, // importance must be at low or higher level
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      autoStartOnBoot: true,
      // auto start service
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      foregroundServiceNotificationId: 112233,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,
      onForeground: onStart,
      // this will be executed when app is in foreground in separated isolate

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  service.on('stopService').listen((event) {
    print("on stop request invoked");
    service.stopSelf();
  });

  await envConfig.initialize();
  _dio = DioClient().dio;
  if (i == 0) {
    _isar = await Isar.open([
      ServiceRegistrySchema,
      LocalizationWrapperSchema,
      AppConfigurationSchema,
      OpLogSchema,
    ]);
    i++;
  }
//  THis delay will be removed once we invoke the service post login.
  // Future.delayed(const Duration(seconds: 30), () async {
  final userRequestModel = await LocalSecureStore.instance.userRequestModel;

  final appConfiguration = await _isar.appConfigurations.where().findAll();
  final interval =
      appConfiguration.first.backgroundServiceConfig?.serviceInterval;
  final frequencyCount =
      appConfiguration.first.backgroundServiceConfig?.apiConcurrency;
  if (interval != null) {
    // TODO: interval will be reomved
    Timer.periodic(Duration(milliseconds: interval * 100), (timer) async {
      if (frequencyCount != null) {
        final serviceRegistryList =
            await _isar.serviceRegistrys.where().findAll();
        if (serviceRegistryList.isNotEmpty) {
          final bandwidthPath = serviceRegistryList
              .firstWhere((element) => element.service == 'BANDWIDTH-CHECK')
              .actions
              .first
              .path;

          List speedArray = [];
          for (var i = 0; i < frequencyCount; i++) {
            final double speed = await BandwidthCheckRepository(
              _dio,
              bandwidthPath: bandwidthPath,
            ).pingBandwidthCheck(bandWidthCheckModel: null);
            speedArray.add(speed);
          }
          int configuredBatchSize =
              getBatchSizeToBandwidth(speedArray.first, appConfiguration);
          final BandwidthModel bandwidthModel = BandwidthModel.fromJson({
            'userId': userRequestModel!.uuid,
            'batchSize': configuredBatchSize,
          });
          const NetworkManager(
            configuration: NetworkManagerConfiguration(
              persistenceConfig: PersistenceConfiguration.offlineFirst,
            ),
          ).performSync(
            localRepositories:
                Constants.getLocalRepositories(_sql, _isar).toList(),
            remoteRepositories: Constants.getRemoteRepositories(
              _dio,
              getActionMap(serviceRegistryList),
            ),
            bandwidthModel: bandwidthModel,
            service: service,
          );
        }
      }
    });
  }
}
// }

getActionMap(List<ServiceRegistry> serviceRegistryList) {
  return serviceRegistryList
      .map((e) => e.actions.map((e) {
            ApiOperation? operation;
            DataModelType? type;

            operation = ApiOperation.values.firstWhereOrNull((element) {
              return e.action.camelCase == element.name;
            });

            type = DataModelType.values.firstWhereOrNull((element) {
              return e.entityName.camelCase == element.name;
            });

            if (operation == null || type == null) return null;

            return ActionPathModel(
              operation: operation,
              type: type,
              path: e.path,
            );
          }))
      .expand((element) => element)
      .whereNotNull()
      .fold(
    <DataModelType, Map<ApiOperation, String>>{},
    (Map<DataModelType, Map<ApiOperation, String>> o, element) {
      if (o.containsKey(element.type)) {
        o[element.type]?.addEntries(
          [MapEntry(element.operation, element.path)],
        );
      } else {
        o[element.type] = Map.fromEntries([
          MapEntry(element.operation, element.path),
        ]);
      }

      return o;
    },
  );
}

int getBatchSizeToBandwidth(
  double speed,
  List<AppConfiguration> appConfiguration,
) {
  late int batchSize;
  final batchResult = appConfiguration.first.bandwidthBatchSize
      ?.where(
        (element) => element.minRange >= speed && element.maxRange <= speed,
      )
      .toList();
  if (batchResult != null) {
    if (batchResult.isNotEmpty) {
      batchSize = int.parse(batchResult.first.batchSize.toString());
    } else if (speed >=
        appConfiguration.first.bandwidthBatchSize!.last.maxRange) {
      batchSize = appConfiguration.first.bandwidthBatchSize!.last.batchSize;
    } else if (speed <=
        appConfiguration.first.bandwidthBatchSize!.first.maxRange) {
      batchSize = appConfiguration.first.bandwidthBatchSize!.first.batchSize;
    }
  }

  return batchSize;
}
