import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

class ViewedItemsTitle extends StatelessWidget {
  const ViewedItemsTitle({
    super.key,
    required this.mainText,
    this.secontText = '',
    this.onTap,
    this.secondTextPressable = true, 
    this.padding = const EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding),
  });
  final String mainText;
  final dynamic secontText;
  final dynamic onTap;
  final bool secondTextPressable;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mainText,
            style: const TextStyle(
              fontWeight: CustomFontsTheme.bigWeight,
              fontSize: CustomFontsTheme.bigSize,
            ),
          ),
          secontText.isEmpty
              ? Text(
                  secontText,
                  style: const TextStyle(
                    color: CustomColorsTheme.descriptionColor,
                    fontWeight: CustomFontsTheme.normalWeight,
                    fontSize: CustomFontsTheme.bigSize,
                  ),
                )
              : InkWell(
                  onTap: secondTextPressable == true ? onTap : null,
                  child: Text(
                    secontText,
                    style: const TextStyle(
                      color: CustomColorsTheme.descriptionColor,
                      fontWeight: CustomFontsTheme.normalWeight,
                      fontSize: CustomFontsTheme.bigSize,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
