import 'package:flutter/material.dart';
import 'package:koolbar_demo/design_system/colors.dart';

class QuickDestinations extends StatelessWidget {
  const QuickDestinations({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.business_center_rounded, 'Office'),
      (Icons.flight_rounded, 'Airport'),
      (Icons.fitness_center_rounded, 'Gym'),
    ];
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: .symmetric(horizontal: 15),
        separatorBuilder: (_, _) => const Padding(padding: .only(left: 10)),
        itemBuilder: (context, index) {
          final item = items[index];
          return ActionChip(
            avatar: Icon(
              item.$1,
              color: index == 1
                  ? KoolbarColors.primary
                  : const Color(0xFFD9E5FA),
              size: 22,
            ),
            label: Text(
              item.$2,
              style: const TextStyle(
                color: Color(0xFFD9E5FA),
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: KoolbarColors.surfaceRaised,
            side: const BorderSide(color: KoolbarColors.border),
            shape: const StadiumBorder(),
            onPressed: () {},
          );
        },
      ),
    );
  }
}
