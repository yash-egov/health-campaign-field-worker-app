// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:complaints/blocs/localization/app_localization.dart' as _i6;
import 'package:complaints/pages/inbox/complaints_inbox.dart' as _i1;
import 'package:complaints/pages/inbox/complaints_inbox_wrapper.dart' as _i2;
import 'package:complaints/pages/registration/complaints_registration_wrapper.dart'
    as _i3;
import 'package:digit_data_model/data_model.dart' as _i7;
import 'package:flutter/material.dart' as _i5;

abstract class $ComplaintsRoute extends _i4.AutoRouterModule {
  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    ComplaintsInboxRoute.name: (routeData) {
      final args = routeData.argsAs<ComplaintsInboxRouteArgs>(
          orElse: () => const ComplaintsInboxRouteArgs());
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ComplaintsInboxPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    ComplaintsInboxWrapperRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ComplaintsInboxWrapperPage(),
      );
    },
    ComplaintsRegistrationWrapperRoute.name: (routeData) {
      final args = routeData.argsAs<ComplaintsRegistrationWrapperRouteArgs>(
          orElse: () => const ComplaintsRegistrationWrapperRouteArgs());
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.WrappedRoute(
            child: _i3.ComplaintsRegistrationWrapperPage(
          key: args.key,
          pgrServiceModel: args.pgrServiceModel,
        )),
      );
    },
  };
}

/// generated route for
/// [_i1.ComplaintsInboxPage]
class ComplaintsInboxRoute extends _i4.PageRouteInfo<ComplaintsInboxRouteArgs> {
  ComplaintsInboxRoute({
    _i5.Key? key,
    _i6.ComplaintsLocalization? appLocalizations,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          ComplaintsInboxRoute.name,
          args: ComplaintsInboxRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'ComplaintsInboxRoute';

  static const _i4.PageInfo<ComplaintsInboxRouteArgs> page =
      _i4.PageInfo<ComplaintsInboxRouteArgs>(name);
}

class ComplaintsInboxRouteArgs {
  const ComplaintsInboxRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final _i5.Key? key;

  final _i6.ComplaintsLocalization? appLocalizations;

  @override
  String toString() {
    return 'ComplaintsInboxRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [_i2.ComplaintsInboxWrapperPage]
class ComplaintsInboxWrapperRoute extends _i4.PageRouteInfo<void> {
  const ComplaintsInboxWrapperRoute({List<_i4.PageRouteInfo>? children})
      : super(
          ComplaintsInboxWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'ComplaintsInboxWrapperRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ComplaintsRegistrationWrapperPage]
class ComplaintsRegistrationWrapperRoute
    extends _i4.PageRouteInfo<ComplaintsRegistrationWrapperRouteArgs> {
  ComplaintsRegistrationWrapperRoute({
    _i5.Key? key,
    _i7.PgrServiceModel? pgrServiceModel,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          ComplaintsRegistrationWrapperRoute.name,
          args: ComplaintsRegistrationWrapperRouteArgs(
            key: key,
            pgrServiceModel: pgrServiceModel,
          ),
          initialChildren: children,
        );

  static const String name = 'ComplaintsRegistrationWrapperRoute';

  static const _i4.PageInfo<ComplaintsRegistrationWrapperRouteArgs> page =
      _i4.PageInfo<ComplaintsRegistrationWrapperRouteArgs>(name);
}

class ComplaintsRegistrationWrapperRouteArgs {
  const ComplaintsRegistrationWrapperRouteArgs({
    this.key,
    this.pgrServiceModel,
  });

  final _i5.Key? key;

  final _i7.PgrServiceModel? pgrServiceModel;

  @override
  String toString() {
    return 'ComplaintsRegistrationWrapperRouteArgs{key: $key, pgrServiceModel: $pgrServiceModel}';
  }
}
