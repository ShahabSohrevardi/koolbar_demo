part of '../pages/ride_destination_page.dart';

class LocationPickerSearchedItem {
  final double latitude;
  final double longitude;
  final String address;

  new({required this.latitude, required this.longitude, required this.address});
}

typedef OnLocationSelect = void Function(LatLng location);

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    required this.onLocationSelect,
    this.isPickupSelected = false,
    this.isDestinationSelected = false,
  });

  final OnLocationSelect onLocationSelect;
  final bool isPickupSelected;
  final bool isDestinationSelected;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker>
    with SingleTickerProviderStateMixin {
  final _overlayPortalController = OverlayPortalController();
  final _linker = LayerLink();
  final _parentKey = GlobalKey();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  Timer? _searchDebounce;

  void _toggleOverlay(bool show) {
    if (show) {
      _overlayPortalController.show();
    } else {
      _overlayPortalController.hide();
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    if (value.trim().length < 2) {
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _requestSearch(value);
    });
  }

  void _requestSearch(String term) {
    final location = context.read<GeolocatorCubit>().state;
    if (location is! GeolocatorSuccess) return;
    context.read<SearchAddressBloc>().add(
      RequestSearchAddress(
        term: term,
        location: {
          'latitude': location.latitude!,
          'longitude': location.longitude!,
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    overlayChildBuilder: (context) => _LocationPickerOverlay(
      layerLink: _linker,
      parentKey: _parentKey,
      onLocationSelect: (item) {
        widget.onLocationSelect(item);
      },
      child: _buildContent(),
      onClose: () {
        _overlayPortalController.hide();
      },
    ),
    controller: _overlayPortalController,
    child: CompositedTransformTarget(
      link: _linker,
      child: GlassPanel(
        key: _parentKey,
        padding: .all(15),
        child: _buildContent(),
      ),
    ),
  );

  Widget _buildContent() => Builder(
    builder: (context) {
      return Stack(
        children: [
          Row(
            children: [
              Column(
                children: [
                  const LocationDot(
                    color: Color(0xFF18DF72),
                    width: 30,
                    height: 30,
                  ),
                  Container(
                    height: 36,
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
                    BlocConsumer<
                      LocationToAddressCubit,
                      LocationToAddressState
                    >(
                      listenWhen: (previous, current) =>
                          !widget.isPickupSelected,
                      listener: (context, state) {
                        if (state is LocationToAddressLoaded) {
                          _pickupController.text = "";
                        }
                      },
                      buildWhen: (previous, current) =>
                          !widget.isPickupSelected,
                      builder: (context, state) {
                        return _LocationTextField(
                          hint:
                              state.entity?.formattedAddress ?? 'Search pickup',
                          controller: _pickupController,
                          isLoading: state is LocationToAddressLoading,
                          onTap: () {
                            _toggleOverlay(true);
                          },
                          onChanged: _onSearchChanged,
                          focusNode: FocusNode(),
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
                    BlocConsumer<
                      LocationToAddressCubit,
                      LocationToAddressState
                    >(
                      buildWhen: (previous, current) =>
                          !widget.isDestinationSelected &&
                          widget.isPickupSelected,
                      listenWhen: (previous, current) =>
                          !widget.isDestinationSelected &&
                          widget.isPickupSelected,
                      listener: (context, state) {
                        if (state is LocationToAddressLoaded) {
                          _destinationController.text = "";
                        }
                      },
                      builder: (context, state) {
                        return _LocationTextField(
                          hint:
                              state.entity?.formattedAddress ??
                              'Where are you going?',
                          isLoading: state is LocationToAddressLoading,
                          controller: _destinationController,
                          onTap: () {
                            _toggleOverlay(true);
                          },
                          focusNode: FocusNode(),
                          onChanged: _onSearchChanged,
                        );
                      },
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
        ],
      );
    },
  );
}

class _LocationPickerOverlay extends StatefulWidget {
  final Widget child;
  final LayerLink layerLink;
  final void Function() onClose;
  final GlobalKey parentKey;
  final OnLocationSelect onLocationSelect;

  const new({
    super.key,
    required this.child,
    required this.layerLink,
    required this.onClose,
    required this.parentKey,
    required this.onLocationSelect,
  });

  @override
  State<_LocationPickerOverlay> createState() => _LocationPickerOverlayState();
}

class _LocationPickerOverlayState extends State<_LocationPickerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animationController.addStatusListener((status) {
      if (status.isDismissed) {
        widget.onClose();
      }
    });
  }

  void _onSelectLocationItem(LatLng location) {
    widget.onLocationSelect(location);
    close();
  }

  void close() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              return Padding(
                padding: .all(15),
                child: Stack(
                  children: [
                    Align(
                      alignment: .topLeft,
                      child: RoundIconButton(
                        onPressed: close,
                        icon: Icons.close,
                      ),
                    ),
                    CompositedTransformFollower(
                      link: widget.layerLink,
                      targetAnchor: .bottomLeft,
                      followerAnchor: .topLeft,
                      offset: Offset(0, 15),
                      child:
                          GlassPanel(
                                padding: .all(15),
                                child: SizedBox(
                                  height: c.maxHeight * .6,
                                  child: Column(
                                    mainAxisSize: .min,
                                    children: [
                                      BlocBuilder<
                                        SearchAddressBloc,
                                        SearchAddressState
                                      >(
                                        builder: (context, state) {
                                          final items = state.searches
                                              ?.map(
                                                (
                                                  e,
                                                ) => LocationPickerSearchedItem(
                                                  latitude: e.location.latitude,
                                                  longitude:
                                                      e.location.longitude,
                                                  address:
                                                      "${e.province},${e.city}",
                                                ),
                                              )
                                              .toList();
                                          return Expanded(
                                            child: state is SearchAddressLoading
                                                ? Shimmer.fromColors(
                                                    baseColor:
                                                        KoolbarColors.surface,
                                                    highlightColor:
                                                        KoolbarColors
                                                            .surfaceRaised,
                                                    child: ListView.separated(
                                                      itemCount: 10,
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Container(
                                                                height: 100,
                                                                color:
                                                                    Colors.teal,
                                                              ),
                                                    ),
                                                  )
                                                : ListView.separated(
                                                    separatorBuilder: (
                                                      context,
                                                      index,
                                                    ) => const Divider(),
                                                    itemCount:
                                                        items?.length ?? 0,
                                                    itemBuilder: (context, index) {
                                                      final item =
                                                          items![index];
                                                      return ListTile(
                                                        onTap: () {
                                                          _onSelectLocationItem(
                                                            LatLng(
                                                              item.latitude,
                                                              item.longitude,
                                                            ),
                                                          );
                                                        },
                                                        title: Text(
                                                          item.address,
                                                        ),
                                                        subtitle: Row(
                                                          mainAxisSize: .min,
                                                          children: [
                                                            Icon(
                                                              Icons.location_on,
                                                            ),
                                                            Text(
                                                              "${item.latitude},${item.longitude}",
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .animate(controller: _animationController)
                              .fadeIn(
                                duration: 300.milliseconds,
                                curve: Curves.easeInOutCubic,
                              )
                              .slideY(
                                begin: -.1,
                                duration: 300.milliseconds,
                                curve: Curves.easeInOutCubic,
                              ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _LocationTextField extends StatelessWidget {
  const _LocationTextField({
    required this.hint,
    required this.onChanged,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    this.isLoading = false,
  });

  final void Function() onTap;
  final bool isLoading;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => isLoading
      ? Padding(
          padding: const .only(top: 8),
          child: Shimmer.fromColors(
            baseColor: KoolbarColors.surface,
            highlightColor: KoolbarColors.surfaceRaised,
            child: Container(
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: .circular(15),
              ),
            ),
          ),
        )
      : TextField(
          onTap: onTap,
          onChanged: onChanged,
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: KoolbarColors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(top: 4, bottom: 4),
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 19,
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
