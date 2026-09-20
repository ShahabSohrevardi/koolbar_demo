import 'package:flutter/material.dart';
import 'package:koolbar_demo/core/systemdesign/card_ui.dart';
import 'package:koolbar_demo/core/systemdesign/colors.dart';
import 'package:koolbar_demo/features/ride_request/presentation/widgets/location_dot.dart';

class LocationPicker extends StatelessWidget {
  const LocationPicker({super.key, required this.onDestinationTap});
  final VoidCallback onDestinationTap;
  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Column(
            children: [
              const LocationDot(color: Color(0xFF18DF72)),
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
                const SizedBox(height: 3),
                const Text(
                  'Current location',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),
                const Text(
                  'Destination',
                  style: TextStyle(
                    color: KoolbarColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                InkWell(
                  onTap: onDestinationTap,
                  child: const Text(
                    'Where are you going?',
                    style: TextStyle(
                      color: KoolbarColors.textSecondary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
}
