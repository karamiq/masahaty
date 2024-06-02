import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import 'custom_button_child.dart';

class SettingsButtons extends StatelessWidget {
  const SettingsButtons({
    super.key,
    required this.buttonsStyles,
    required this.buttonsFunctions,
    required this.buttonsPrefixIcons,
    required this.buttonsText,
    this.padding = const EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding),
    this.suffixIcon,
  });

  final List<ButtonStyle> buttonsStyles;
  final List<VoidCallback> buttonsFunctions;
  final List<Icon> buttonsPrefixIcons;
  final List<String> buttonsText;
  final Icon? suffixIcon;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 120,
        child: ListView.separated(
            itemCount: buttonsText.length,
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemBuilder: (context, index) => OutlinedButton(
                style: buttonsStyles[index],
                onPressed: buttonsFunctions[index],
                child: CustomButtonChild(
                  prefixIcon: buttonsPrefixIcons[index],
                  suffixIcon: suffixIcon ??
                      const Icon(Icons
                          .chevron_right), // Use an empty Container if suffixIcon is null
                  text: buttonsText[index],
                ))),
      ),
    );
  }
}
