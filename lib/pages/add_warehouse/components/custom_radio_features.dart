import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../core/constants/constants.dart';

class CustomRadioFeatures extends StatefulWidget {
  const CustomRadioFeatures({super.key, required this.val, required this.onChange});
  final ValueChanged<bool> onChange;
  final bool val;

  @override
  State<CustomRadioFeatures> createState() => _CustomRadioFeaturesState();
}

class _CustomRadioFeaturesState extends State<CustomRadioFeatures> {
  late bool _val;

  @override
  void initState() {
    super.initState();
    _val = widget.val;
  }

  void _handleRadioValueChange(bool? value) {
    if (value != null) {
      setState(() {
        _val = value;
      });
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
        border: Border.all(
          color: CustomColorsTheme.dividerColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: _val,
                fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return CustomColorsTheme.availableRadioColor;
                  }
                  return CustomColorsTheme.availableRadioColor;
                }),
                onChanged: _handleRadioValueChange,
              ),
              Text(
                AppLocalizations.of(context)!.avialble,
                style: const TextStyle(
                  color: CustomColorsTheme.availableRadioColor,
                  fontSize: CustomFontsTheme.bigSize,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Center(
            child: VerticalDivider(
              color: CustomColorsTheme.dividerColor,
            ),
          ),
          Row(
            children: [
              Radio<bool>(
                value: false,
                groupValue: _val,
                fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return CustomColorsTheme.unAvailableRadioColor;
                  }
                  return CustomColorsTheme.unAvailableRadioColor;
                }),
                onChanged: _handleRadioValueChange,
              ),
              Text(
                AppLocalizations.of(context)!.notAvailble,
                style: const TextStyle(
                  color: CustomColorsTheme.unAvailableRadioColor,
                  fontSize: CustomFontsTheme.bigSize,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
