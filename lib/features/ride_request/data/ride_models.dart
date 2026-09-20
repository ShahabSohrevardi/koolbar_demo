import 'package:flutter/material.dart';

class Place {
  const Place({
    required this.name,
    required this.address,
    required this.distance,
    required this.icon,
    this.iconColor,
  });

  final String name;
  final String address;
  final String distance;
  final IconData icon;
  final Color? iconColor;
}

class RideOption {
  const RideOption({
    required this.name,
    required this.price,
    required this.icon,
    required this.color,
  });

  final String name;
  final String price;
  final IconData icon;
  final Color color;
}
