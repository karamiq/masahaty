
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../core/constants/constants.dart';
class DynamicText extends StatelessWidget {
  const DynamicText({super.key, required this.contant});
  final String contant;
  @override
  Widget build(BuildContext context) {
    return Text(
      contant,
      style: TextStyle(
        color: contant == AppLocalizations.of(context)!.notAvailble
            ? CustomColorsTheme.unAvailableRadioColor
            : CustomColorsTheme.availableRadioColor,
        fontSize: CustomFontsTheme.bigSize,
      ),
    );
  }
}
