import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/utils/utils.dart';

extension ContextUtilityExtensions on BuildContext {
  int millisecondsSinceEpoch([DateTime? dateTime]) {
    return (dateTime ?? DateTime.now()).millisecondsSinceEpoch;
  }

  DataRepository<D, R>
  repository<D extends EntityModel, R extends EntitySearchModel>(
      BuildContext context,
      ) {
    switch (ComplaintsSingleton().persistenceConfiguration) {
      case PersistenceConfiguration.offlineFirst:
        return context.read<LocalRepository<D, R>>();
      case PersistenceConfiguration.onlineOnly:
        return context.read<RemoteRepository<D, R>>();
      default:
        return context.read<LocalRepository<D, R>>();
    }
  }

  // String get loggedInUserUuid => loggedInUser.uuid;

}