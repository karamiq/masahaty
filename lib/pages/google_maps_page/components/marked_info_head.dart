
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui'as ui;
import '../../../components/custom_comments_button.dart';
import '../../../components/custom_favorites_button.dart';
import '../../../components/viewed_item_title.dart';
import '../../../core/constants/constants.dart';
import '../../../models/warehouse_model.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MarkedInfoHead extends StatelessWidget {
  const MarkedInfoHead({
    super.key,
    required this.markedWarehouse,
  });

  final Warehouse? markedWarehouse;

  @override
  Widget build(BuildContext context) {
    dynamic formattedPrice =
          NumberFormat.decimalPattern().format(markedWarehouse!.price);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ViewedItemsTitle(
                mainText: markedWarehouse!.name,
                padding: const EdgeInsets.all(0),
              ),
              const SizedBox(height: CustomPageTheme.smallPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star,
                    size: CoustomIconTheme.verySmallize,
                    color: CustomColorsTheme.starColor,
                  ),
                  Text(
                    markedWarehouse!.rating.toString(),
                    style: const TextStyle(
                        color: CustomColorsTheme.descriptionColor),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: CustomPageTheme.smallPadding),
                    child: Icon(
                      Icons.circle,
                      size: CoustomIconTheme.verySmallize / 3,
                      color: ui.Color.fromRGBO(112, 120, 125, 1),
                    ),
                  ),
                  const Icon(Icons.location_on_outlined,
                      color: CustomColorsTheme.headLineColor,
                      size: CoustomIconTheme.verySmallize),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomPageTheme.smallPadding),
                    child: Text(
                      '${markedWarehouse!.city['govName']}, ${markedWarehouse!.address}',
                      maxLines: 1,
                      style: const TextStyle(
                          color: CustomColorsTheme.descriptionColor),
                    ),
                  ),
                ],
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomFavoritesButton(id: markedWarehouse!.id),
          CustomCommentsButton(id: markedWarehouse!.id),
            ],
          )
        ],
      ),
    );
  }
}
