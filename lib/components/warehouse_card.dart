import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/components/custom_favorites_button.dart';
import 'package:masahaty/components/custom_rating_button.dart';
import 'package:masahaty/pages/wharehouse_pages/warehouse_details_page.dart';
import '../core/constants/constants.dart';


class WarehouseCard extends StatefulWidget {
  const WarehouseCard({
    super.key,
    required this.governorate,
    required this.district,
    required this.title,
    required this.discription,
    required this.imagePath,
    required this.price,
    required this.id,
    required this.rating,
  });

  final String id;
  final String governorate;
  final String district;
  final String title;
  final String discription;
  final String imagePath;
  final double price;
  final double rating;

  @override
  createState() => _WarehouseCardState();
}

class _WarehouseCardState extends State<WarehouseCard> {
  @override
  Widget build(BuildContext context) {
    void warehouseInfoPage() async {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (c) => WarehouseDetailesPage(id: widget.id)),
      );
       // This will refresh the state when you return to this page
       //when changing the favorite status
      setState(() {});
    }
    final formattedPrice = NumberFormat.decimalPattern().format(widget.price);

    return InkWell(
      onTap: () => warehouseInfoPage(),
      child: Container(
        padding: const EdgeInsets.all(CustomPageTheme.normalPadding),
        height: 337,
        width: 377,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.1),
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                 gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 0, 158, 204),
                          Color.fromARGB(255, 0, 101, 132),
                        ]),
                borderRadius: BorderRadius.circular(
                    CoustomBorderTheme.normalBorderRaduis),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        CoustomBorderTheme.normalBorderRaduis),
                    child: Image.network(
                      widget.imagePath,
                      height: 200,
                      width: 347,
                      fit: BoxFit.cover,
                    ),
                  ),
                 Padding(
                   padding: const EdgeInsets.all(CustomPageTheme.smallPadding),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomFavoritesButton(id: widget.id),
                      CustomRatingButton(warehouseRating: widget.rating, id: widget.id)
                    ],
                   ),
                 )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: CustomFontsTheme.bigWeight,
                fontSize: CustomFontsTheme.bigSize,
              ),
            ),
            Text(
              widget.discription,
              maxLines: 2,
              style: const TextStyle(
                color: CustomColorsTheme.descriptionColor,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: CustomColorsTheme.headLineColor),
                    Text('${widget.governorate}, ${widget.district}'),
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
          ],
        ),
      ),
    );
  }
}
