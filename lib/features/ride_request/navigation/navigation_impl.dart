import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/app/app_route.gr.dart';
import 'package:koolbar_demo/features/ride_request/api/navigation.dart';

@LazySingleton(as: RideRequestNavigation, scope: "RideRequestApi")
class RideRequestNavigationImpl implements RideRequestNavigation {
  @override
  void navigateToNewSavedLocation(BuildContext context) {
    context.router.pushNewSavedLocation();
  }

  @override
  void navigateToRideOptionPage(
    BuildContext context,
    (double, double) pickup,
    (double, double) destination,
  ) {
    context.router.pushRideOptions(pickup, destination);
  }
}

extension RideRequestNavigationExtension on StackRouter {
  void pushNewSavedLocation() => push(NewSavedLocationRoute());
  void pushRideOptions((double, double) pickup, (double, double) destination) =>
      push(RideOptionsRoute(pickup: pickup, destination: destination));
}
