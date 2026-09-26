import 'package:auto_route/auto_route.dart';
import 'package:koolbar_demo/app/app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Screen|Page,Route")
class AppRouter extends RootStackRouter {
  @override
  // TODO: implement routes
  List<AutoRoute> get routes => [
    AutoRoute(
      page: RideRequestWrapperRoute.page,
      children: [
        AutoRoute(
          page: RideDestinationRoute.page,
          initial: true,
          path: "request-dest",
        ),
        AutoRoute(page: RideOptionsRoute.page, path: "ride-option"),
      ],
      initial: true,
      path: "/dashboard",
    ),
  ];
}
