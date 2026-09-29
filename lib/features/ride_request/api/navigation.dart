import 'package:flutter/widgets.dart';

mixin RideRequestNavigation {
  void navigateToNewSavedLocation(BuildContext context);

  void navigateToRideOptionPage(
    BuildContext context,
    (double, double) pickup,
    (double, double) destination,
  );
}
