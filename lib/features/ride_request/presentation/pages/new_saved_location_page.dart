import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:koolbar_demo/app/bloc/geolocator/geolocator_cubit.dart';
import 'package:koolbar_demo/core/utilities/map_locations.dart';
import 'package:koolbar_demo/design_system/card_ui.dart';
import 'package:koolbar_demo/design_system/colors.dart';
import 'package:koolbar_demo/design_system/error/snack_bar.dart';
import 'package:koolbar_demo/design_system/map/select_location_map.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/presentation/bloc/location_to_address_bloc/location_to_address_cubit.dart';
import 'package:koolbar_demo/features/ride_request/presentation/bloc/save_location_bloc/new_saved_location_cubit.dart';
import 'package:koolbar_demo/features/ride_request/presentation/bloc/search_address_bloc/search_address_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:shimmer/shimmer.dart';

part '../widgets/location_search.dart';

@RoutePage()
class NewSavedLocationPage extends StatefulWidget implements AutoRouteWrapper {
  const NewSavedLocationPage({super.key});

  @override
  State<NewSavedLocationPage> createState() => _NewSavedLocationPageState();

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GetIt.I.get<SearchAddressBloc>()),
      BlocProvider(create: (context) => GetIt.I.get<LocationToAddressCubit>()),
    ],
    child: this,
  );
}

class _NewSavedLocationPageState extends State<NewSavedLocationPage> {
  MapLibreMapController? _mapController;
  LatLng? _centerLocation;
  Timer? _searchBounce;

  void _sendLocationToAddress(double latitude, double longitude) {
    _searchBounce?.cancel();
    _searchBounce = Timer(300.milliseconds, () {
      context.read<LocationToAddressCubit>().sendLocation(latitude, longitude);
      _centerLocation = LatLng(latitude, longitude);
    });
  }

  void _moveMapCamera(LatLng locations) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: locations, zoom: 14),
      ),
    );
  }

  void _showConfirmLocationDialog(BuildContext context) async {
    if (_centerLocation == null) {
      showErrorSnackBar(context, "err_current_location_not_found");
    }
    final SavedLocationEntity? newSavedLocation =
        await showDialog<SavedLocationEntity>(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: .circular(15)),
              child: BlocProvider(
                create: (context) => GetIt.I.get<NewSavedLocationCubit>(),
                child: _SelectLocationDialog(
                  latitude: _centerLocation!.latitude,
                  longitude: _centerLocation!.longitude,
                ),
              ),
            );
          },
        );
    if (newSavedLocation != null) {
      this.context.router.maybePop(newSavedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: BlocConsumer<GeolocatorCubit, GeolocatorState>(
                listener: (context, state) {
                  if (state is GeolocatorSuccess) {
                    _centerLocation = LatLng(state.latitude!, state.longitude!);
                  }
                },
                builder: (context, state) {
                  var location = LatLng(
                    MapLocations.tehran.latitude,
                    MapLocations.tehran.longitude,
                  );
                  if (state is GeolocatorSuccess) {
                    location = LatLng(state.latitude!, state.longitude!);
                  }
                  return SelectLocationMap(
                    currentLocation: location,
                    onMapReady: (controller) {
                      _mapController = controller;
                    },
                    onCenterPositionChanged: (location) {
                      _centerLocation = location;
                      _sendLocationToAddress(
                        location.latitude,
                        location.longitude,
                      );
                    },
                  );
                },
              ),
            ),
            BlocBuilder<GeolocatorCubit, GeolocatorState>(
              builder: (context, state) {
                if (state is GeolocatorLoading) {
                  return Container();
                }
                return Padding(
                  padding: .all(15),
                  child: LocationSearch(
                    onLocationSelect: (location) {
                      _moveMapCamera(location);
                    },
                    currentLocation: LatLng(state.latitude!, state.longitude!),
                    isLoading: state is GeolocatorLoading,
                  ),
                );
              },
            ),
            BlocBuilder<LocationToAddressCubit, LocationToAddressState>(
              builder: (context, state) {
                return Align(
                  alignment: .bottomCenter,
                  child: Container(
                    margin: const .all(15),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is LocationToAddressLoading
                          ? null
                          : () {
                              _showConfirmLocationDialog(context);
                            },
                      child: Text("title_confirm_location"),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectLocationDialog extends StatefulWidget {
  const _SelectLocationDialog({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  State<_SelectLocationDialog> createState() => _SelectLocationDialogState();
}

class _SelectLocationDialogState extends State<_SelectLocationDialog> {
  IconData? _selectedIcon;
  final _textController = TextEditingController();
  late final Map<String, Widget> _icons;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Widget buildIcon(String name, IconData icon) {
      return ActionChip(
        label: Text(name),
        onPressed: () {
          _textController.text = name;
          _selectIcon(icon);
        },
        shape: StadiumBorder(),
        color: WidgetStatePropertyAll(KoolbarColors.surfaceRaised),
        avatar: Icon(icon),
      );
    }

    _icons = {
      "air": buildIcon("Air Port", Icons.local_airport),
      "gym": buildIcon("Gym", Icons.fitness_center),
      "home": buildIcon("Home", Icons.home),
    };
  }

  void _selectIcon(IconData icon) {
    setState(() {
      _selectedIcon = icon;
    });
  }

  void _saveLocation() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    context.read<NewSavedLocationCubit>().saveNewLocation(
      NewSavedLocationEntity(
        name: _textController.text,
        latitude: widget.latitude,
        longitude: widget.longitude,
        iconCodePoint: _selectedIcon?.codePoint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocListener<NewSavedLocationCubit, NewSaveLocationState>(
        listener: (context, state) {
          if (state is SaveLocationSuccess) {
            context.router.maybePop(state.savedLocation);
          }
        },
        child: GlassPanel(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "err_validation_location_name_empty";
                  }
                  return null;
                },
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Location Name",
                  filled: false,
                ),
              ),
              const SizedBox(height: 15),
              Text("Icons", style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                children: _icons.keys.map((e) {
                  return Padding(
                    padding: const .only(left: 8),
                    child: _icons[e]!,
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              BlocBuilder<NewSavedLocationCubit, NewSaveLocationState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: state is SaveLocationLoading
                          ? null
                          : _saveLocation,
                      child: (state is SaveLocationLoading)
                          ? Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Text("title_confirm_location"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
