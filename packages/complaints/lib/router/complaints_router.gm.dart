// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:complaints/blocs/localization/app_localization.dart' as _i5;
import 'package:complaints/pages/inbox/complaints_inbox.dart' as _i1;
import 'package:complaints/pages/inbox/complaints_inbox_wrapper.dart' as _i2;
import 'package:flutter/material.dart' as _i4;

abstract class $ComplaintsRoute extends _i3.AutoRouterModule {
  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    ComplaintsInboxRoute.name: (routeData) {
      final args = routeData.argsAs<ComplaintsInboxRouteArgs>(
          orElse: () => const ComplaintsInboxRouteArgs());
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ComplaintsInboxPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    ComplaintsInboxWrapperRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ComplaintsInboxWrapperPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.ComplaintsInboxPage]
class ComplaintsInboxRoute extends _i3.PageRouteInfo<ComplaintsInboxRouteArgs> {
  ComplaintsInboxRoute({
    _i4.Key? key,
    _i5.ComplaintsLocalization? appLocalizations,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          ComplaintsInboxRoute.name,
          args: ComplaintsInboxRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'ComplaintsInboxRoute';

  static const _i3.PageInfo<ComplaintsInboxRouteArgs> page =
      _i3.PageInfo<ComplaintsInboxRouteArgs>(name);
}

class ComplaintsInboxRouteArgs {
  const ComplaintsInboxRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final _i4.Key? key;

  final _i5.ComplaintsLocalization? appLocalizations;

  @override
  String toString() {
    return 'ComplaintsInboxRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [_i2.ComplaintsInboxWrapperPage]
class ComplaintsInboxWrapperRoute extends _i3.PageRouteInfo<void> {
  const ComplaintsInboxWrapperRoute({List<_i3.PageRouteInfo>? children})
      : super(
          ComplaintsInboxWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'ComplaintsInboxWrapperRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}
