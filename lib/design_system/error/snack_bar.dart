import 'package:flutter/material.dart';
import 'package:koolbar_demo/design_system/colors.dart';

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: KoolbarColors.danger,
      duration: const Duration(seconds: 1),
      showCloseIcon: true,
    ),
  );
}
