import 'package:flutter/material.dart';
import 'package:koolbar_demo/design_system/colors.dart';
import 'package:koolbar_demo/design_system/map/map_style.dart';
import 'package:koolbar_demo/design_system/map/types.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class SelectLocationMap extends StatefulWidget {
  const SelectLocationMap({
    super.key,
    required this.currentLocation,
    required this.onMapReady,
    required this.onCenterPositionChanged,
  });

  final OnMapReady onMapReady;
  final OnMapCenterPositionChanged onCenterPositionChanged;
  final LatLng currentLocation;
  @override
  State<SelectLocationMap> createState() => _SelectLocationMapState();
}

class _SelectLocationMapState extends State<SelectLocationMap> {
  MapLibreMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapLibreMap(
          styleString: darkMapStyle,
          onMapCreated: (controller) async {
            _mapController = controller;
            widget.onMapReady(controller);
          },
          trackCameraPosition: true,
          myLocationEnabled: true,
          onCameraMove: (cameraPosition) {
            widget.onCenterPositionChanged(cameraPosition.target);
          },
          onCameraIdle: () {
            if(_mapController!=null){
              final location=_mapController!.cameraPosition?.target;
              if(location!=null){
                widget.onCenterPositionChanged(location);
              }
            }
          },
          initialCameraPosition: CameraPosition(
            zoom: 12,
            target: widget.currentLocation,
          ),
        ),
        Center(
          child: Icon(Icons.location_on, color: KoolbarColors.danger, size: 40),
        ),
      ],
    );
  }
}
