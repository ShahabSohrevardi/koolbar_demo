// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:koolbar_demo/features/ride_request/presentation/pages/rd_route_wrapper_page.dart'
    as _i3;
import 'package:koolbar_demo/features/ride_request/presentation/pages/ride_destination_page.dart'
    as _i1;
import 'package:koolbar_demo/features/ride_request/presentation/pages/ride_options_page.dart'
    as _i2;

/// generated route for
/// [_i1.RideDestinationPage]
class RideDestinationRoute extends _i4.PageRouteInfo<void> {
  const RideDestinationRoute({List<_i4.PageRouteInfo>? children})
    : super(RideDestinationRoute.name, initialChildren: children);

  static const String name = 'RideDestinationRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.WrappedRoute(child: const _i1.RideDestinationPage());
    },
  );
}

/// generated route for
/// [_i2.RideOptionsPage]
class RideOptionsRoute extends _i4.PageRouteInfo<RideOptionsRouteArgs> {
  RideOptionsRoute({
    _i5.Key? key,
    required (double, double) pickup,
    required (double, double) destination,
    List<_i4.PageRouteInfo>? children,
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

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RideOptionsRouteArgs>();
      return _i2.RideOptionsPage(
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

  final _i5.Key? key;

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
/// [_i3.RideRequestWrapperPage]
class RideRequestWrapperRoute extends _i4.PageRouteInfo<void> {
  const RideRequestWrapperRoute({List<_i4.PageRouteInfo>? children})
    : super(RideRequestWrapperRoute.name, initialChildren: children);

  static const String name = 'RideRequestWrapperRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.WrappedRoute(child: const _i3.RideRequestWrapperPage());
    },
  );
}
