import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../../core/constants/constants.dart';

class SelectGov extends StatelessWidget {
  const SelectGov(
      {super.key,
      required this.onTap,
      required this.selectedGovermnt,
      required this.stateIsValid});

  final Function() onTap;
  final String selectedGovermnt;

  final bool? stateIsValid;
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        errorText: stateIsValid == false ? AppLocalizations.of(context)!.phoneNumberErrorEmpty :null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: CustomColorsTheme.dividerColor, width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: CustomColorsTheme.dividerColor, width: 1)),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(selectedGovermnt),
        trailing: const Icon(
          Icons.keyboard_arrow_down,
          color: CustomColorsTheme.headLineColor,
        ),
      ),
    );
  }
}
