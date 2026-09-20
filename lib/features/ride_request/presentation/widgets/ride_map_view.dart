import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:koolbar_demo/core/systemdesign/colors.dart';

/// A dark MapLibre map used for both choosing a pin and previewing a ride.
class RideMapView extends StatefulWidget {
  const RideMapView({
    super.key,
    this.showRoute = false,
    this.showCenterPin = false,
    required this.currentLocation
  });

  final LatLng currentLocation;
  final bool showRoute;
  final bool showCenterPin;

  @override
  State<RideMapView> createState() => _RideMapViewState();
}

class _RideMapViewState extends State<RideMapView> {
  static const _start = LatLng(1.2902, 103.8519);
  static const _end = LatLng(1.3083, 103.8568);
  static const _route = [
    _start,
    LatLng(1.2912, 103.8529),
    LatLng(1.2910, 103.8556),
    LatLng(1.2944, 103.8559),
    LatLng(1.2978, 103.8582),
    LatLng(1.3004, 103.8592),
    LatLng(1.3027, 103.8581),
    _end,
  ];

  MapLibreMapController? _controller;
  var _routeAdded = false;

  Future<void> _drawRoute() async {
    final controller = _controller;
    if (!widget.showRoute || controller == null || _routeAdded) return;

    _routeAdded = true;
    await controller.addLine(
      const LineOptions(
        geometry: _route,
        lineColor: '#10D9B2',
        lineWidth: 15,
        lineBlur: 0.45,
        lineOpacity: 0.42,
        lineJoin: 'round',
      ),
    );
    await controller.addLine(
      const LineOptions(
        geometry: _route,
        lineColor: '#14DDF4',
        lineWidth: 6,
        lineJoin: 'round',
      ),
    );
    await controller.addCircles(const [
      CircleOptions(
        geometry: _start,
        circleRadius: 12,
        circleColor: '#10D9B2',
        circleStrokeColor: '#B0FFE9',
        circleStrokeWidth: 3,
      ),
      CircleOptions(
        geometry: _end,
        circleRadius: 13,
        circleColor: '#FF6473',
        circleStrokeColor: '#FFD1D6',
        circleStrokeWidth: 3,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.showRoute ? widget.currentLocation : _start;
    return Stack(
      fit: StackFit.expand,
      children: [
        MapLibreMap(
          styleString:_darkMapStyle,
          initialCameraPosition: CameraPosition(target: target, zoom: 14.3),
          compassEnabled: false,
          logoEnabled: false,
          attributionButtonPosition: AttributionButtonPosition.bottomRight,
          onMapCreated: (controller) => _controller = controller,
          onStyleLoadedCallback: _drawRoute,
        ),
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  KoolbarColors.background.withValues(alpha: .05),
                  KoolbarColors.background.withValues(alpha: .28),
                ],
              ),
            ),
          ),
        ),
        if (widget.showCenterPin) const _CenterPin(),
      ],
    );
  }
}

class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.only(bottom: 32),
      child: Icon(
        Icons.location_on_rounded,
        size: 54,
        color: KoolbarColors.danger,
        shadows: [Shadow(color: Color(0xAAFF6473), blurRadius: 20)],
      ),
    ),
  );
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
