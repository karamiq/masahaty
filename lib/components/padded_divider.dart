
import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

class PaddedDivider extends StatelessWidget {
  const PaddedDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:  EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding),
      child:  Divider(endIndent: 5,color: CustomColorsTheme.dividerColor),
    );
  }
}