import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:koolbar_demo/design_system/colors.dart';

/// MapLibre preview of the selected pickup and destination.
class RideMapView extends StatefulWidget {
  const RideMapView({
    super.key,
    required this.initialLocation,
    this.pickup,
    this.destination,
  });

  final LatLng? pickup;
  final LatLng? destination;
  final LatLng initialLocation;

  @override
  State<RideMapView> createState() => _RideMapViewState();
}

class _RideMapViewState extends State<RideMapView> {
  MapLibreMapController? _controller;
  var _styleLoaded = false;

  @override
  void didUpdateWidget(covariant RideMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.pickup != widget.pickup ||
    //     oldWidget.destination != widget.destination ||
    //     oldWidget.initialLocation != widget.initialLocation) {
    //   _refreshAnnotations();
    // }
  }

  Future<void> _refreshAnnotations() async {
    final controller = _controller;
    if (controller == null || !_styleLoaded) return;

    await controller.clearLines();
    await controller.clearCircles();

    final pickup = widget.pickup;
    final destination = widget.destination;
    final circles = <CircleOptions>[
      if (pickup != null)
        CircleOptions(
          geometry: pickup,
          circleRadius: 12,
          circleColor: '#10D9B2',
          circleStrokeColor: '#B0FFE9',
          circleStrokeWidth: 3,
        ),
      if (destination != null)
        CircleOptions(
          geometry: destination,
          circleRadius: 13,
          circleColor: '#FF6473',
          circleStrokeColor: '#FFD1D6',
          circleStrokeWidth: 3,
        ),
    ];
    if (circles.isNotEmpty) await controller.addCircles(circles);

    if (pickup != null && destination != null) {
      final points = [pickup, destination];
      await controller.addLine(
        LineOptions(
          geometry: points,
          lineColor: '#10D9B2',
          lineWidth: 15,
          lineBlur: .45,
          lineOpacity: .42,
          lineJoin: 'round',
        ),
      );
      await controller.addLine(
        LineOptions(
          geometry: points,
          lineColor: '#14DDF4',
          lineWidth: 6,
          lineJoin: 'round',
        ),
      );
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              math.min(pickup.latitude, destination.latitude),
              math.min(
                pickup.longitude,
                destination.longitude,
              ),
            ),
            northeast: LatLng(
              math.max(pickup.latitude, destination.latitude),
              math.max(
                pickup.longitude,
                destination.longitude,
              ),
            ),
          ),
          left: 48,
          top: 80,
          right: 48,
          bottom: 150,
        ),
      );
    } else if (pickup != null || destination != null) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom((pickup ?? destination)!, 14.8),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      MapLibreMap(
        styleString: _darkMapStyle,
        initialCameraPosition: CameraPosition(
          target: widget.initialLocation,
          zoom: 14.3,
        ),
        compassEnabled: false,
        logoEnabled: false,
        attributionButtonPosition: AttributionButtonPosition.bottomRight,
        onMapCreated: (controller) => _controller = controller,
        onStyleLoadedCallback: () {
          _styleLoaded = true;
          _refreshAnnotations();
        },
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
    ],
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
