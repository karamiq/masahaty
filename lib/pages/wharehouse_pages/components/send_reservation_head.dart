import 'package:flutter/material.dart';

import '../../../components/viewed_item_title.dart';
import '../../../core/constants/constants.dart';
import '../../../models/storage&features_model.dart';

class SendReservationHead extends StatelessWidget {
  const SendReservationHead({
    super.key,
    required this.currentWarehouse,
  });

  final Storage? currentWarehouse;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 0, 158, 204),
                    Color.fromARGB(255, 0, 101, 132),
                  ]),
            ),
            child: Image.network(
                width: 120,
                height: 80,
                fit: BoxFit.cover,
                currentWarehouse!.images[1]),
          ),
        ),
        const SizedBox(
          width: CustomPageTheme.normalPadding,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ViewedItemsTitle(
              mainText: currentWarehouse!.name,
              padding: const EdgeInsets.all(0),
            ),
            const SizedBox(
              height: CustomPageTheme.smallPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.star,
                  size: CoustomIconTheme.verySmallize,
                  color: CustomColorsTheme.starColor,
                ),
                Text(
                  currentWarehouse!.rating.toString(),
                  style: const TextStyle(
                      color: CustomColorsTheme.descriptionColor),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: CustomPageTheme.smallPadding),
                  child: Icon(
                    Icons.circle,
                    size: CoustomIconTheme.verySmallize / 3,
                    color: CustomColorsTheme.descriptionColor,
                  ),
                ),
                const Icon(Icons.location_on_outlined,
                    color: CustomColorsTheme.headLineColor,
                    size: CoustomIconTheme.verySmallize),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomPageTheme.smallPadding),
                  child: Text(
                    '${currentWarehouse!.city?.govName ?? 'to do here'}, ${currentWarehouse!.address}',
                    style: const TextStyle(
                        color: CustomColorsTheme.descriptionColor),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
