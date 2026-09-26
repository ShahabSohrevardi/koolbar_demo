import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:koolbar_demo/app/app_route.dart';
import 'package:koolbar_demo/app/bloc/geolocator/geolocator_cubit.dart';
import 'package:koolbar_demo/app/bloc/permission/app_permission_cubit.dart';
import 'package:koolbar_demo/app/di.dart';

import 'app/theme/koolbar_theme.dart';

import 'package:koolbar_demo/design_system/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initConfiguration();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I.get<AppPermissionCubit>()),
        BlocProvider(create: (context) => GetIt.I.get<GeolocatorCubit>()),
      ],
      child: KoolbarApp(),
    ),
  );
}

class KoolbarApp extends StatelessWidget {
  final _appRoute = AppRouter();

  KoolbarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Koolbar Ride',
      debugShowCheckedModeBanner: false,
      theme: KoolbarTheme.dark(),
      builder: (context, child) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-.9, -.9),
            radius: 1.4,
            colors: [Color(0xFF182943), KoolbarColors.background],
          ),
        ),
        child: child,
      ),
      routerConfig: _appRoute.config(),
    );
  }
}
