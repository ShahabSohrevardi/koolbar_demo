import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:koolbar_demo/core/utilities/svg_bytes.dart';
import 'package:koolbar_demo/design_system/colors.dart';
import 'package:koolbar_demo/core/utils/map_locations.dart';
import 'package:koolbar_demo/design_system/map/location_attribute_widgets.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class SelectTwoPointMap extends StatefulWidget {
  final LatLng? currentLocation;
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final void Function(LatLng center) onChangeCenterLocation;
  final void Function(MapLibreMapController mapController) onMapReady;

  const new({
    super.key,
    required this.currentLocation,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.onChangeCenterLocation,
    required this.onMapReady,
  });

  @override
  State<SelectTwoPointMap> createState() => _SelectTwoPointMapState();
}

class _SelectTwoPointMapState extends State<SelectTwoPointMap> {
  MapLibreMapController? _mapController;
  late final LatLng? _centerLocation;
  Symbol? _pickupSymbol;
  Symbol? _destinationSymbol;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _refreshAnnotations() async {
    if (widget.pickupLocation != null) {
      _pickupSymbol = await _mapController?.addSymbol(
        SymbolOptions(
          geometry: widget.pickupLocation,
          iconImage: "marker-id",
          iconSize: 3,
          // textField: "Start"
        ),
      );
    } else if (_pickupSymbol != null) {
      _mapController?.removeSymbol(_pickupSymbol!);
      _mapController?.clearSymbols();
      _pickupSymbol = null;
    }
    if (widget.destinationLocation != null) {
      _destinationSymbol = await _mapController?.addSymbol(
        SymbolOptions(
          geometry: widget.destinationLocation,
          iconImage: "marker-stroke-id",
          iconSize: 3,
          // textField: "End"
        ),
      );
    } else if (_destinationSymbol != null) {
      _mapController?.removeSymbol(_destinationSymbol!);
      _mapController?.clearSymbols();
      _destinationSymbol=null;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _refreshAnnotations();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshAnnotations();
    });
    return Stack(
      children: [
        MapLibreMap(
          styleString: _darkMapStyle,
          onMapCreated: (controller) async {
            _mapController = controller;
            final markerBytes = await svgToPngBytes("assets/icons/marker.svg");
            final markerStrokeBytes = await svgToPngBytes(
              "assets/icons/marker-stroked.svg",
            );
            await controller.addImage("marker-id", markerBytes);
            await controller.addImage("marker-stroke-id", markerStrokeBytes);
            widget.onMapReady(controller);
          },
          trackCameraPosition: true,
          myLocationEnabled: true,
          onCameraMove: (cameraPosition) {
            if (_centerLocation != null) {
              widget.onChangeCenterLocation(cameraPosition.target);
            }
          },
          onCameraIdle: () {
            if (_mapController != null) {
              _centerLocation = _mapController!.cameraPosition?.target;
              if (_centerLocation != null) {
                widget.onChangeCenterLocation(_centerLocation);
              }
            }
          },
          initialCameraPosition: CameraPosition(
            zoom: 12,
            target:
                widget.currentLocation ??
                LatLng(
                  MapLocations.tehran.latitude,
                  MapLocations.tehran.longitude,
                ),
          ),
        ),
        Center(
          child: AnimatedCrossFade(
            firstChild: Icon(
              Icons.location_on,
              color: KoolbarColors.danger,
              size: 40,
            ),
            secondChild: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              children: [
                LocationDot(color: Colors.green, width: 40, height: 40),
                Container(height: 10, width: 2, color: Colors.black87),
              ],
            ),
            crossFadeState: widget.pickupLocation != null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: 300.milliseconds,
          ),
        ),
      ],
    );
  }
}

const _darkMapStyle = '''
{
  "version": 8,
  "name": "Koolbar dark",
  "sources": {
    "openstreetmap": {
      "type": "raster",
      "tiles": ["https://tile.openstreetmap.org/{z}/{x}/{y}.png"],
      "tileSize": 256,
      "attribution": "© OpenStreetMap contributors"
    }
  },
  "layers": [
    {"id": "background", "type": "background", "paint": {"background-color": "#07111f"}},
    {
      "id": "openstreetmap",
      "type": "raster",
      "source": "openstreetmap",
      "paint": {
        "raster-opacity": 0.72,
        "raster-brightness-min": 0.04,
        "raster-brightness-max": 0.48,
        "raster-saturation": -0.72,
        "raster-contrast": 0.35,
        "raster-hue-rotate": 198
      }
    }
  ]
}
''';
