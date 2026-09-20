import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:koolbar_demo/core/systemdesign/card_ui.dart';
import 'package:koolbar_demo/core/systemdesign/colors.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../models/ride_models.dart';

@RoutePage()
class RideOptionsPage extends StatefulWidget {
  const RideOptionsPage({super.key, required this.destination});

  final String destination;

  @override
  State<RideOptionsPage> createState() => _RideOptionsPageState();
}

class _RideOptionsPageState extends State<RideOptionsPage> {
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
  static const _options = [
    RideOption(
      name: 'Economy',
      price: '\$10.20',
      icon: Icons.directions_car_filled_rounded,
      color: Color(0xFFE3EAF5),
    ),
    RideOption(
      name: 'Comfort',
      price: '\$14.50',
      icon: Icons.directions_car_filled_rounded,
      color: Color(0xFFC5CFDE),
    ),
    RideOption(
      name: 'Green/EV',
      price: '\$12.90',
      icon: Icons.electric_car_rounded,
      color: Color(0xFF5CD4AD),
    ),
    RideOption(
      name: 'Business',
      price: '\$21.00',
      icon: Icons.directions_car_filled_rounded,
      color: Color(0xFF7B8CA3),
    ),
  ];

  var _selected = 1;

  RideOption get _selectedOption => _options[_selected];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _RideMap(start: _start, end: _end, route: _route),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _DestinationPill(destination: widget.destination),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _RideSheet(
              selected: _selected,
              options: _options,
              onChanged: (index) => setState(() => _selected = index),
              confirmLabel:
                  'Confirm ${_selectedOption.name} Ride • ${_selectedOption.price}',
            ),
          ),
        ],
      ),
    );
  }
}

class _RideMap extends StatelessWidget {
  const _RideMap({required this.start, required this.end, required this.route});

  final LatLng start;
  final LatLng end;
  final List<LatLng> route;

  @override
  Widget build(BuildContext context) => ColorFiltered(
    colorFilter: const ColorFilter.matrix([
      .36,
      0,
      0,
      0,
      0,
      0,
      .48,
      0,
      0,
      4,
      0,
      0,
      .70,
      0,
      18,
      0,
      0,
      0,
      1,
      0,
    ]),
    child: Builder(
      builder: (context) {
        final api_key = dotenv.get("NESHAN_API_KEY");
        return MapLibreMap(
          styleString:
              "https://static.neshan.org/sdk/maplibre/styles/light.json",
          initialCameraPosition: CameraPosition(
            target: LatLng(35.6892, 51.3890),
            zoom: 15,
          ),
        );
      },
    ),
    // FlutterMap(
    //   options: const MapOptions(
    //     initialCenter: LatLng(1.2985, 103.8565),
    //     initialZoom: 14.3,
    //   ),
    //   children: [
    //     Builder(
    //       builder: (context) {
    //         final api_key=dotenv.get("NESHAN_API_KEY");
    //         return TileLayer(
    //           urlTemplate: 'https://api.neshan.org/v5/static?key=$api_key&style=light&zoom=12&width=620&height=400&latitude=35.75542836926&longitude=51.177361249324&marker=',
    //           userAgentPackageName: 'com.illu.koolbar_demo',
    //         );
    //       }
    //     ),
    //     PolylineLayer(
    //       polylines: [
    //         Polyline(
    //           points: route,
    //           strokeWidth: 14,
    //           color: const Color(0x6610D9B2),
    //           strokeCap: StrokeCap.round,
    //           strokeJoin: StrokeJoin.round,
    //         ),
    //         Polyline(
    //           points: route,
    //           strokeWidth: 6,
    //           color: KoolbarColors.cyan,
    //           strokeCap: StrokeCap.round,
    //           strokeJoin: StrokeJoin.round,
    //         ),
    //       ],
    //     ),
    //     MarkerLayer(
    //       markers: [
    //         Marker(
    //           point: start,
    //           width: 54,
    //           height: 54,
    //           child: const _StartMarker(),
    //         ),
    //         Marker(
    //           point: end,
    //           width: 58,
    //           height: 66,
    //           child: const _EndMarker(),
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
  );
}

class _StartMarker extends StatelessWidget {
  const _StartMarker();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: KoolbarColors.primary,
      border: Border.all(color: const Color(0xFF9DFFE8), width: 3),
      boxShadow: const [BoxShadow(color: Color(0xAA10D9B2), blurRadius: 18)],
    ),
    child: const Icon(
      Icons.person_pin_circle_rounded,
      color: Colors.white,
      size: 30,
    ),
  );
}

class _EndMarker extends StatelessWidget {
  const _EndMarker();

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topCenter,
    children: [
      Container(
        height: 48,
        width: 48,
        decoration: const BoxDecoration(
          color: KoolbarColors.danger,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0xAAFF6473), blurRadius: 18)],
        ),
        child: const Icon(
          Icons.location_on_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      const Positioned(
        top: 40,
        child: Icon(
          Icons.arrow_drop_down_rounded,
          size: 28,
          color: KoolbarColors.danger,
        ),
      ),
    ],
  );
}

class _DestinationPill extends StatelessWidget {
  const _DestinationPill({required this.destination});

  final String destination;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 220),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: KoolbarColors.background.withValues(alpha: .86),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: KoolbarColors.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.place_rounded, color: KoolbarColors.danger, size: 18),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            destination,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

class _RideSheet extends StatelessWidget {
  const _RideSheet({
    required this.selected,
    required this.options,
    required this.onChanged,
    required this.confirmLabel,
  });

  final int selected;
  final List<RideOption> options;
  final ValueChanged<int> onChanged;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
    decoration: const BoxDecoration(
      color: Color(0xFF0C1829),
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      border: Border(top: BorderSide(color: KoolbarColors.border)),
      boxShadow: [
        BoxShadow(
          color: Color(0x99000000),
          blurRadius: 30,
          offset: Offset(0, -10),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Grabber(),
          const SizedBox(height: 16),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _RideOptionCard(
                option: options[index],
                selected: index == selected,
                onTap: () => onChanged(index),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GlassPanel(
            radius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A39A8),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Text(
                    'VISA',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Add promo',
                  style: TextStyle(
                    color: KoolbarColors.cyan,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: KoolbarColors.cyan,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: confirmLabel,
            onPressed: () {},
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF031913),
              size: 22,
            ),
          ),
        ],
      ),
    ),
  );
}

class _RideOptionCard extends StatelessWidget {
  const _RideOptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final RideOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 145,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF10323B) : KoolbarColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? KoolbarColors.primary : KoolbarColors.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? const [BoxShadow(color: Color(0x4410D9B2), blurRadius: 16)]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  option.icon,
                  size: 64,
                  color: option.color,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
            ),
            Text(
              option.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            const Text(
              '3 min away',
              style: TextStyle(
                color: KoolbarColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0x44F64263),
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFFFF7890),
                    size: 15,
                  ),
                  SizedBox(width: 3),
                  Text(
                    '1.2x',
                    style: TextStyle(
                      color: Color(0xFFFF7890),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
