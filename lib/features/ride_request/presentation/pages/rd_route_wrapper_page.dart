import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koolbar_demo/app/di.config.dart';
import 'package:koolbar_demo/app/di.dart';

@RoutePage()
class RideRequestWrapperPage extends StatefulWidget implements AutoRouteWrapper{
  const RideRequestWrapperPage({super.key});
  @override
  State<StatefulWidget> createState() => RideRequestWrapperPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}

class RideRequestWrapperPageState extends State<RideRequestWrapperPage> {
  @override
  void initState() {
    getIt.initRideRequestScope();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    getIt.popScope();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => AutoRouter();
}
