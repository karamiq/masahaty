import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = CustomColorsTheme.headLineColor,
    this.icon,
  });
  final Function()? onPressed;
  final Widget label;
  final Color backgroundColor;
  final Icon? icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    CoustomBorderTheme.normalBorderRaduis))),
        onPressed: onPressed,
        label: label,
        icon: icon,
        );
  }
}
