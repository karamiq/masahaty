
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../../core/constants/constants.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.start, 
    required this.type,
  });

  final String startDate;
  final String endDate;
  final String start;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: CustomPageTheme.normalPadding,
          vertical: CustomPageTheme.smallPadding,
        ),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
          border: Border.all(
            color: CustomColorsTheme.dividerColor,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.orderDateOfStart,
                          style: const TextStyle(
                              color: CustomColorsTheme.descriptionColor),
                        ),
                        Text(startDate),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: CustomPageTheme.bigPadding * 2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.orderDataOfEnd,
                          style: const TextStyle(
                              color: CustomColorsTheme.descriptionColor),
                        ),
                        Text(
                          endDate,
                          style: const TextStyle(
                              color: CustomColorsTheme.unAvailableRadioColor),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                const Divider(
                  color: CustomColorsTheme.dividerColor,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.storagingCount,
                          style: const TextStyle(
                              color: CustomColorsTheme.descriptionColor),
                        ),
                        Text(start),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: CustomPageTheme.bigPadding * 3,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.storagingType,
                          style: const TextStyle(
                              color: CustomColorsTheme.descriptionColor),
                        ),
                        Text(type),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
            const Center(
              child: VerticalDivider(
                color: CustomColorsTheme.dividerColor,
              ),
            ),
          ],
        ));
  }
}
