// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:koolbar_demo/features/ride_request/presentation/pages/new_saved_location_page.dart'
    as _i1;
import 'package:koolbar_demo/features/ride_request/presentation/pages/rd_route_wrapper_page.dart'
    as _i4;
import 'package:koolbar_demo/features/ride_request/presentation/pages/ride_destination_page.dart'
    as _i2;
import 'package:koolbar_demo/features/ride_request/presentation/pages/ride_options_page.dart'
    as _i3;

/// generated route for
/// [_i1.NewSavedLocationPage]
class NewSavedLocationRoute extends _i5.PageRouteInfo<void> {
  const NewSavedLocationRoute({List<_i5.PageRouteInfo>? children})
    : super(NewSavedLocationRoute.name, initialChildren: children);

  static const String name = 'NewSavedLocationRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return _i5.WrappedRoute(child: const _i1.NewSavedLocationPage());
    },
  );
}

/// generated route for
/// [_i2.RideDestinationPage]
class RideDestinationRoute extends _i5.PageRouteInfo<void> {
  const RideDestinationRoute({List<_i5.PageRouteInfo>? children})
    : super(RideDestinationRoute.name, initialChildren: children);

  static const String name = 'RideDestinationRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return _i5.WrappedRoute(child: const _i2.RideDestinationPage());
    },
  );
}

/// generated route for
/// [_i3.RideOptionsPage]
class RideOptionsRoute extends _i5.PageRouteInfo<RideOptionsRouteArgs> {
  RideOptionsRoute({
    _i6.Key? key,
    required (double, double) pickup,
    required (double, double) destination,
    List<_i5.PageRouteInfo>? children,
  }) : super(
         RideOptionsRoute.name,
         args: RideOptionsRouteArgs(
           key: key,
           pickup: pickup,
           destination: destination,
         ),
         initialChildren: children,
       );

  static const String name = 'RideOptionsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RideOptionsRouteArgs>();
      return _i3.RideOptionsPage(
        key: args.key,
        pickup: args.pickup,
        destination: args.destination,
      );
    },
  );
}

class RideOptionsRouteArgs {
  const RideOptionsRouteArgs({
    this.key,
    required this.pickup,
    required this.destination,
  });

  final _i6.Key? key;

  final (double, double) pickup;

  final (double, double) destination;

  @override
  String toString() {
    return 'RideOptionsRouteArgs{key: $key, pickup: $pickup, destination: $destination}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RideOptionsRouteArgs) return false;
    return key == other.key &&
        pickup == other.pickup &&
        destination == other.destination;
  }

  @override
  int get hashCode => key.hashCode ^ pickup.hashCode ^ destination.hashCode;
}

/// generated route for
/// [_i4.RideRequestWrapperPage]
class RideRequestWrapperRoute extends _i5.PageRouteInfo<void> {
  const RideRequestWrapperRoute({List<_i5.PageRouteInfo>? children})
    : super(RideRequestWrapperRoute.name, initialChildren: children);

  static const String name = 'RideRequestWrapperRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return _i5.WrappedRoute(child: const _i4.RideRequestWrapperPage());
    },
  );
}
