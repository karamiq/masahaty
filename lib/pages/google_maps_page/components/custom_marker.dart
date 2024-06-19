
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({
    super.key,
    required this.price,
    required this.currency,
  });

  final String price;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: CustomPageTheme.normalPadding / 1.5,
              vertical: CustomPageTheme.smallPadding / 2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  CoustomBorderTheme.normalBorderRaduis * 2)),
          child: Text(
            '$currency $price',
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        const Icon(
          Icons.place,
          color: CustomColorsTheme.headLineColor,
          size: 35,
        ),
      ],
    );
  }
}
