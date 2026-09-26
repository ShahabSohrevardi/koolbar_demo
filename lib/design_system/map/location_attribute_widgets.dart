import 'package:flutter/material.dart';

class LocationDot extends StatelessWidget {
  const LocationDot({
    super.key,
    required this.color,
    required this.width,
    required this.height,
  });

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: width,
    width: height,
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
