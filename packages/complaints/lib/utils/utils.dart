import 'package:digit_data_model/data_model.dart';


//singleton class for complaints operations
class ComplaintsSingleton{
  static final ComplaintsSingleton _singleton = ComplaintsSingleton._internal();

  // Factory constructor that returns the singleton instance.
  factory ComplaintsSingleton() {
    return _singleton;
  }

  //Private constructor for the singleton pattern
  ComplaintsSingleton._internal();

  //various properties related to the inventory
  String? _tenantId = '';
  String? _loggedInUserUuid ='';
  PersistenceConfiguration _persistenceConfiguration = PersistenceConfiguration
      .offlineFirst; // Default to offline first persistence configuration

  void setInitialData({
    String? tenantId,
    String? loggedInUserUuid,
  }){
    _tenantId = tenantId;
    _loggedInUserUuid = loggedInUserUuid;
  }

  void setPersistenceConfiguration(PersistenceConfiguration configuration) {
    _persistenceConfiguration = configuration;
  }

  void setTenantId({required String tenantId}) {
    _tenantId = tenantId;
  }

  get tenantId => _tenantId;
  get loggedInUserUuid => _loggedInUserUuid;
  get persistenceConfiguration => _persistenceConfiguration;


}