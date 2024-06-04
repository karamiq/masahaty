
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../components/viewed_item_title.dart';
import '../../../core/constants/constants.dart';
import '../../../models/storage&features_model.dart';

class WarehouseTitleAndPrice extends StatelessWidget {
  const WarehouseTitleAndPrice({
    super.key,
    required this.currentWarehouse,
    required this.formattedPrice,
  });

  final Storage currentWarehouse;
  final dynamic formattedPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ViewedItemsTitle(
          padding: const EdgeInsets.all(0),
          mainText: currentWarehouse.name,
        ),
        Row(
          children: [
            Text(
              '$formattedPrice ${AppLocalizations.of(context)!.iqd}',
              style: const TextStyle(
                color: CustomColorsTheme.headLineColor,
                fontWeight: CustomFontsTheme.bigWeight,
              ),
            ),
            Text(
              '/${AppLocalizations.of(context)!.night}',
              style: const TextStyle(
                color: CustomColorsTheme.descriptionColor,
                fontWeight: CustomFontsTheme.bigWeight,
              ),
            ),
          ],
        )
      ],
    );
  }
}
