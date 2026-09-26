import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:koolbar_demo/design_system/map/location_attribute_widgets.dart';
import 'package:koolbar_demo/design_system/map/two_point_map.dart';
import 'package:koolbar_demo/features/ride_request/presentation/bloc/location_to_address_bloc/location_to_address_cubit.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:koolbar_demo/app/app_route.gr.dart';
import 'package:koolbar_demo/app/bloc/geolocator/geolocator_cubit.dart';
import 'package:koolbar_demo/app/bloc/permission/app_permission_cubit.dart';
import 'package:koolbar_demo/design_system/card_ui.dart';
import 'package:koolbar_demo/design_system/colors.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/presentation/bloc/search_address_bloc/search_address_bloc.dart';
import 'package:koolbar_demo/features/ride_request/presentation/widgets/quick_destinations.dart';
import 'package:shimmer/shimmer.dart';

part '../widgets/location_picker.dart';

@RoutePage()
class RideDestinationPage extends StatefulWidget implements AutoRouteWrapper {
  const RideDestinationPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<SearchAddressBloc>(
        create: (_) => GetIt.I.get<SearchAddressBloc>(),
      ),
      BlocProvider<LocationToAddressCubit>(
        create: (_) => GetIt.I.get<LocationToAddressCubit>(),
      ),
    ],
    child: this,
  );

  @override
  State<RideDestinationPage> createState() => _RideDestinationPageState();
}

class _RideDestinationPageState extends State<RideDestinationPage> {
  LatLng? _initializeLocation;
  Timer? _searchDebounce;
  LatLng? _pickup;
  LatLng? _destination;
  AddressEntity? _currentCenterAddress;
  LatLng? _currentCenterLocation;
  MapLibreMapController? _mapController;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _setPlaces() {}

  void _changeCenterLocationToEntity(LatLng center) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 700), () {
      _currentCenterLocation = center;
      context.read<LocationToAddressCubit>().sendLocation(
        center.latitude,
        center.longitude,
      );
    });
  }

  void _selectPickupLocation() {
    setState(() {
      _pickup = _currentCenterLocation;
      _currentCenterLocation = null;
    });
  }

  Future<void> _ensureCurrentLocation() async {
    final permissionCubit = context.read<AppPermissionCubit>();
    final isGranted = await permissionCubit.isLocationPermissionGranted();
    if (!mounted) return;
    if (isGranted) {
      if (context.read<GeolocatorCubit>().state is! GeolocatorSuccess) {
        context.read<GeolocatorCubit>().getCurrentLocation();
      }
    } else {
      context.read<AppPermissionCubit>().askLocationPermission();
    }
  }

  void _confirmLocations() {
    if (_currentCenterLocation == null) return;
    if (_pickup == null) {
      setState(() {
        _pickup = _currentCenterLocation;
        _currentCenterLocation = null;
      });
    } else if (_destination == null) {
      setState(() {
        _destination = _currentCenterLocation;
      });
    } else {
      context.router.push(
        RideOptionsRoute(
          pickup: (_pickup!.latitude, _pickup!.longitude),
          destination: (_destination!.latitude, _destination!.longitude),
        ),
      );
    }
  }

  void _changeCameraPosition(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 12),
      ),
    );
  }

  void _onBackPressed() {
    if (_pickup != null) {
      if (_mapController?.cameraPosition?.target == _pickup) {
        setState(() {
          _pickup = null;
        });
        return;
      }
      _changeCameraPosition(_pickup!);
    } else if (_destination != null) {
      if (_mapController?.cameraPosition?.target == _destination) {
        setState(() {
          _destination = null;
        });
        return;
      }
      _changeCameraPosition(_destination!);
    }
  }

  @override
  Widget build(BuildContext context) => MultiBlocListener(
    listeners: [
      BlocListener<AppPermissionCubit, AppPermissionState>(
        listener: (context, state) {},
      ),
      BlocListener<GeolocatorCubit, GeolocatorState>(
        listener: (context, state) {
          if (state is GeolocatorSuccess && _initializeLocation == null) {
            setState(() {
              _initializeLocation = LatLng(state.latitude!, state.longitude!);
            });
          }
        },
      ),
      BlocListener<LocationToAddressCubit, LocationToAddressState>(
        listener: (context, state) {
          if (state is LocationToAddressLoaded) {
            _currentCenterAddress = state.entity;
          }
        },
      ),
    ],
    child: Builder(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _ensureCurrentLocation();
        });
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: BlocBuilder<GeolocatorCubit, GeolocatorState>(
                    builder: (context, state) {
                      return SelectTwoPointMap(
                        currentLocation: _initializeLocation,
                        onChangeCenterLocation: (center) {
                          _changeCenterLocationToEntity(center);
                        },
                        onMapReady: (mapController) {
                          _mapController = mapController;
                        },
                        pickupLocation: _pickup,
                        destinationLocation: _destination,
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_pickup != null || _destination != null)
                                RoundIconButton(
                                  icon: Icons.arrow_back_ios_new_rounded,
                                  onPressed: _onBackPressed,
                                ),
                              const Text(
                                'Where to?',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: KoolbarColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          LocationPicker(
                            onLocationSelect: (location) {
                              _mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(target: location, zoom: 12),
                                ),
                                duration: 300.milliseconds,
                              );
                            },
                            isPickupSelected: _pickup != null,
                            isDestinationSelected: _destination != null,
                          ),
                        ],
                      ),
                    ),
                    const QuickDestinations(),
                  ],
                ),
                Align(
                  alignment: .bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child:
                          BlocBuilder<
                            LocationToAddressCubit,
                            LocationToAddressState
                          >(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state is LocationToAddressLoading
                                    ? null
                                    : _confirmLocations,
                                child: Text("select_picked_up_location"),
                              );
                            },
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _RoutePlaceLabel extends StatelessWidget {
  const _RoutePlaceLabel({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}
