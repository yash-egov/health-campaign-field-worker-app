import 'package:auto_route/auto_route.dart';

import 'complaints_router.gm.dart';

@AutoRouterConfig.module()
class ComplaintsRoute extends $ComplaintsRoute {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> routes =[
    /// Complaints Inbox
    AutoRoute(
      page: ComplaintsInboxWrapperRoute.page,
      path: 'complaints-inbox',
      children: [
        AutoRoute(
          page: ComplaintsInboxRoute.page,
          path: 'complaints-inbox-items',
          initial: true,
        ),
      //   AutoRoute(
      //     page: ComplaintsInboxFilterRoute.page,
      //     path: 'complaints-inbox-filter',
      //   ),
      //   AutoRoute(
      //     page: ComplaintsInboxSearchRoute.page,
      //     path: 'complaints-inbox-search',
      //   ),
      //   AutoRoute(
      //     page: ComplaintsInboxSortRoute.page,
      //     path: 'complaints-inbox-sort',
      //   ),
      //   AutoRoute(
      //     page: ComplaintsDetailsViewRoute.page,
      //     path: 'complaints-inbox-view-details',
      //   ),
      ],
    ),

  ];

}