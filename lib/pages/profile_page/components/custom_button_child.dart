
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class CustomButtonChild extends StatelessWidget {
  const CustomButtonChild({
    super.key, required this.prefixIcon, required this.suffixIcon, required this.text,
  });
  final Icon prefixIcon;
  final Icon suffixIcon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:13 ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              prefixIcon,
              const SizedBox(width: CustomPageTheme.smallPadding,),
              Text(text,
                style: const TextStyle(
                  fontSize: CustomFontsTheme.bigSize
                ),
              ),
            ],
          ),
          suffixIcon
        ],
      ),
    );
  }
}