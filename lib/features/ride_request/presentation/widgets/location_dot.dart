import 'package:flutter/material.dart';

class LocationDot extends StatelessWidget {
  const LocationDot({super.key, required this.color});
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
