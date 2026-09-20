import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:koolbar_demo/app/bloc/geolocator/geolocator_cubit.dart';
import 'package:koolbar_demo/app/bloc/permission/app_permission_cubit.dart';
import 'package:koolbar_demo/core/systemdesign/card_ui.dart';
import 'package:koolbar_demo/features/ride_request/presentation/bloc/search_address_bloc/search_address_bloc.dart';
import 'package:koolbar_demo/features/ride_request/presentation/widgets/quick_destinations.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:shimmer/shimmer.dart';

import '../models/ride_models.dart';
import '../widgets/ride_map_view.dart';

import 'package:koolbar_demo/core/systemdesign/colors.dart';

import 'ride_options_page.dart';

@RoutePage()
class RideDestinationPage extends StatefulWidget implements AutoRouteWrapper {
  const RideDestinationPage({super.key});

  @override
  State<RideDestinationPage> createState() => _RideDestinationPageState();

  @override
  Widget wrappedRoute(BuildContext context) => this;
}

class _RideDestinationPageState extends State<RideDestinationPage> {
  final _pickupFocus = FocusNode();
  final _destinationFocus = FocusNode();
  final _pickupController = TextEditingController(text: 'Current location');
  final _destinationController = TextEditingController();
  var _showMapSelection = false;

  @override
  void dispose() {
    _pickupFocus.dispose();
    _destinationFocus.dispose();
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _activateMapSelection(FocusNode focusNode) {
    context.read<AppPermissionCubit>().isLocationPermissionGranted().then((
      value,
    ) {
      if (!value) {
        context.read<AppPermissionCubit>().askLocationPermission();
      } else {
        context.read<GeolocatorCubit>().getCurrentLocation();
        focusNode.requestFocus();
        if (!_showMapSelection) setState(() => _showMapSelection = true);
      }
    });
  }

  void _openRideOptions(Place place) {
    _destinationController.text = place.name;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RideOptionsPage(destination: place.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppPermissionCubit, AppPermissionState>(
          listener: (context, state) {
            if (state is LocationPermissionGranted) {
              context.read<GeolocatorCubit>().getCurrentLocation();
            }
          },
        ),
        BlocListener<GeolocatorCubit, GeolocatorState>(
          listener: (context, state) {
            if (state is GeolocatorSuccess) {
              if (!_showMapSelection) setState(() => _showMapSelection = true);
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-.9, -.9),
              radius: 1.4,
              colors: [Color(0xFF182943), KoolbarColors.background],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () {},
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
                  _LocationPicker(
                    pickupFocus: _pickupFocus,
                    destinationFocus: _destinationFocus,
                    pickupController: _pickupController,
                    destinationController: _destinationController,
                    onPickupTap: () => _activateMapSelection(_pickupFocus),
                    onDestinationTap: () =>
                        _activateMapSelection(_destinationFocus),
                  ),
                  const SizedBox(height: 16),
                  const QuickDestinations(),
                  const SizedBox(height: 28),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _showMapSelection
                          ? SizedBox.expand(
                              key: const ValueKey('map-selection'),
                              child: _MapSelectionPane(
                                onBack: () =>
                                    setState(() => _showMapSelection = false),
                              ),
                            )
                          : SizedBox.expand(
                              key: const ValueKey('saved-places'),
                              child: Container(),
                              // _SavedPlacesPane(
                              //   recentPlaces: _recentPlaces,
                              //   savedPlaces: _savedPlaces,
                              //   onPlaceTap: _openRideOptions,
                              //   onSetPin: () =>
                              //       _activateMapSelection(_destinationFocus),
                              // ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationPicker extends StatelessWidget {
  const _LocationPicker({
    required this.pickupFocus,
    required this.destinationFocus,
    required this.pickupController,
    required this.destinationController,
    required this.onPickupTap,
    required this.onDestinationTap,
  });

  final FocusNode pickupFocus;
  final FocusNode destinationFocus;
  final TextEditingController pickupController;
  final TextEditingController destinationController;
  final VoidCallback onPickupTap;
  final VoidCallback onDestinationTap;
  final bool isLoading = false;

  @override
  Widget build(BuildContext context) => GlassPanel(
    padding: const EdgeInsets.all(18),
    child: Row(
      children: [
        Column(
          children: [
            const _LocationDot(color: Color(0xFF18DF72)),
            Container(
              height: 30,
              width: 2,
              color: KoolbarColors.primary.withValues(alpha: .45),
            ),
            const Icon(
              Icons.location_on_rounded,
              color: KoolbarColors.danger,
              size: 32,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pickup location',
                style: TextStyle(
                  color: KoolbarColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              BlocConsumer<SearchAddressBloc, SearchAddressState>(
                bloc: GetIt.I.get<SearchAddressBloc>(),
                listener: (context, state) {},
                builder: (context, searchState) {
                  return BlocConsumer<GeolocatorCubit, GeolocatorState>(
                    builder: (context, state) {
                      return _LocationTextField(
                        controller: pickupController,
                        focusNode: pickupFocus,
                        isLoading:
                            searchState is SearchAddressLoading ||
                            state is GeolocatorLoading,
                        hint: 'Current location',
                        onTap: onPickupTap,
                        onChanged: (value) {
                          if (state is GeolocatorSuccess) {
                            context.read<SearchAddressBloc>().add(
                              RequestSearchAddress(
                                term: value ?? "",
                                location: {
                                  "latitude": state.latitude,
                                  "longitude": state.longitude,
                                },
                              ),
                            );
                          }
                        },
                        onSubmitted: (_) {},
                      );
                    },
                    listener: (context, state) {},
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              const Text(
                'Destination',
                style: TextStyle(
                  color: KoolbarColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              _LocationTextField(
                controller: destinationController,
                focusNode: destinationFocus,
                isLoading: false,
                onChanged: (value) {},
                hint: 'Where are you going?',
                onTap: onDestinationTap,
                onSubmitted: (_) {},
              ),
            ],
          ),
        ),
        RoundIconButton(
          icon: Icons.swap_vert_rounded,
          size: 48,
          onPressed: () {},
        ),
      ],
    ),
  );
}

class _LocationTextField extends StatelessWidget {
  const _LocationTextField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onTap,
    required this.onChanged,
    required this.onSubmitted,
    required this.isLoading,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final VoidCallback onTap;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String?> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => isLoading
      ? Shimmer.fromColors(
          baseColor: KoolbarColors.surface,
          highlightColor: KoolbarColors.surfaceRaised,
          child: Row(
            children: [Container(width: 200, height: 20, color: Colors.white)],
          ),
        )
      : TextField(
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: KoolbarColors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(top: 4, bottom: 4),
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: KoolbarColors.textSecondary,
            ),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        );
}

class _LocationDot extends StatelessWidget {
  const _LocationDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    height: 32,
    width: 32,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .15),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    ),
  );
}

class _MapSelectionPane extends StatelessWidget {
  const _MapSelectionPane({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GeolocatorCubit, GeolocatorState>(
        builder: (context, state) {
          if (state is GeolocatorSuccess) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: RideMapView(
                      showCenterPin: true,
                      currentLocation: LatLng(state.latitude, state.longitude),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: RoundIconButton(
                      icon: Icons.close_rounded,
                      size: 46,
                      onPressed: onBack,
                    ),
                  ),
                  Positioned(
                    right: 14,
                    left: 14,
                    bottom: 16,
                    child: GlassPanel(
                      radius: 18,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.open_with_rounded,
                            color: KoolbarColors.primary,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Move the map to set your pin',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox(
            width: 30,
            height: 30,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.action,
    required this.children,
  });

  final String title;
  final String action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFFC2D0E8),
              ),
            ),
            Text(
              action,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: KoolbarColors.primary,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(children: children),
      ),
    ],
  );
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({required this.place, required this.onTap});

  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: KoolbarColors.surfaceRaised,
              shape: BoxShape.circle,
            ),
            child: Icon(
              place.icon,
              color: place.iconColor ?? const Color(0xFFD6E3F8),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  place.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: KoolbarColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                place.distance,
                style: const TextStyle(
                  color: Color(0xFFB5C4DB),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              const Icon(
                Icons.chevron_right_rounded,
                color: KoolbarColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
