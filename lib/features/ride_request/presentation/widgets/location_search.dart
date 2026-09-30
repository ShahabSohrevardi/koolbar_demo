part of '../pages/new_saved_location_page.dart';

class LocationSearch extends StatefulWidget {
  LocationSearch({
    super.key,
    required this.currentLocation,
    this.isLoading = false,
    required this.onLocationSelect,
  });

  final bool isLoading;
  final LatLng currentLocation;
  final void Function(LatLng location) onLocationSelect;

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch>
    with SingleTickerProviderStateMixin {
  final _searchTextController = TextEditingController();
  Timer? _timer;
  late final AnimationController _animationController;
  late final CurvedAnimation _animation;
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _searchTextController.addListener(() {
      setState(() {
        _isSearching = _searchTextController.text.isNotEmpty;
      });
      _timer?.cancel();
      _timer = Timer(300.milliseconds, () {
        if (_searchTextController.text.isNotEmpty) {
          _animationController.forward();
          context.read<SearchAddressBloc>().add(
            RequestSearchAddress(
              term: _searchTextController.text,
              location: {
                "latitude": widget.currentLocation.latitude,
                "longitude": widget.currentLocation.longitude,
              },
            ),
          );
        } else {
          _animationController.reverse();
        }
      });
    });
  }

  void _close() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocConsumer<LocationToAddressCubit, LocationToAddressState>(
                listener: (context, state) {
                  _searchTextController.clear();
                },
                builder: (context, state) {
                  return state is LocationToAddressLoading
                      ? Shimmer.fromColors(
                          baseColor: KoolbarColors.surface,
                          highlightColor: KoolbarColors.surfaceRaised,
                          child: Container(
                            width: double.infinity,
                            height: 30,
                            color: Colors.green,
                          ),
                        )
                      : TextField(
                          onTap: () {},
                          controller: _searchTextController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: KoolbarColors.textSecondary,
                              fontSize: 19,
                            ),
                            isDense: true,
                            contentPadding: const .all(15),
                            hintText:
                                state.entity?.formattedAddress ??
                                "Search location",
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: _isSearching
                                ? IconButton(
                                    onPressed: () {
                                      _searchTextController.clear();
                                    },
                                    icon: Icon(Icons.close),
                                  )
                                : Icon(Icons.search),
                          ),
                        );
                },
              ),
              SizeTransition(
                sizeFactor: _animation,
                child: SizedBox(
                  height: c.maxHeight * .7,
                  child: Column(
                    children: [
                      Expanded(
                        child:
                            BlocConsumer<SearchAddressBloc, SearchAddressState>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                if (state is SearchAddressLoading) {
                                  return Shimmer.fromColors(
                                    baseColor: KoolbarColors.surface,
                                    highlightColor: KoolbarColors.surfaceRaised,
                                    child: ListView.separated(
                                      itemCount: 10,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 10),
                                      itemBuilder: (context, index) =>
                                          Container(
                                            height: 100,
                                            color: Colors.teal,
                                          ),
                                    ),
                                  );
                                }
                                return ListView.separated(
                                  itemBuilder: (context, index) {
                                    final item = state.searches![index];
                                    return ListTile(
                                      title: Text(
                                        "${item.province},${item.city}",
                                      ),
                                      onTap: () {
                                        widget.onLocationSelect(item.location);
                                        _close();
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: state.searches?.length ?? 0,
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
