
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class DetailsTableRow extends StatelessWidget {
  const DetailsTableRow({
    super.key,
    required this.titelIcon,
    required this.titelText,
    required this.currentLanguage,
    required this.titleIfo,
    this.borderRadius,
  });

  final Icon titelIcon;
  final String titelText;
  final Locale? currentLanguage;
  final Text titleIfo;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CustomPageTheme.normalPadding),
                height: 40,
                width: 30,
                decoration: BoxDecoration(
                    color: const Color(0xFFDCE4E9), borderRadius: borderRadius),
                child: Row(
                  children: [
                    titelIcon,
                    const SizedBox(
                      width: CustomPageTheme.smallPadding,
                    ),
                    Text(
                      titelText,
                      style: const TextStyle(color: Color(0xFF40484C)),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: currentLanguage != const Locale('en')
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                    horizontal: CustomPageTheme.normalPadding),
                height: 40,
                width: 30,
                color: Colors.white,
                child: titleIfo,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 1,
        )
      ],
    );
  }
}