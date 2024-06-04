
import 'package:flutter/material.dart';
import 'package:masahaty/pages/closest_to_you/closest_to_you.dart';
import 'package:masahaty/pages/home_page/components/categories_sequare_types.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../components/viewed_item_title.dart';
import '../../../components/warehouse_card.dart';
import '../../../core/constants/constants.dart';
import '../../../models/warehouse_model.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({
    super.key,
    required this.storagesRecentlyAdded,
    required this.storagesClosestToYou,
  });

  final List<Warehouse>? storagesRecentlyAdded;
  final List<Warehouse>? storagesClosestToYou;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewedItemsTitle(
          mainText: AppLocalizations.of(context)!.recentlyAdded,
          secontText: AppLocalizations.of(context)!.more,
          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (c) => MorePage(storagesRecentlyAdded!))),
        ),
        const SizedBox(height: CustomPageTheme.bigPadding,),
        SizedBox(
          height: 337,
          child: storagesRecentlyAdded == null || storagesRecentlyAdded!.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemCount: storagesRecentlyAdded!.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 20,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Warehouse warehouse = storagesRecentlyAdded![index];
                    return WarehouseCard(
                      rating: warehouse.rating,
                      id: warehouse.id,
                      governorate: warehouse.city['govName'],
                      district: warehouse.city['name'],
                      title: warehouse.name,
                      discription: warehouse.description,
                      imagePath: warehouse.images[0],
                      price: warehouse.price,
                    );
                  },
                ),
        ),
        const SizedBox(
          height: CustomPageTheme.bigPadding,
        ),
        ViewedItemsTitle(
          mainText: AppLocalizations.of(context)!.warehouseCategories,
        ),
        const CategoriesSequareTypes(),
        ViewedItemsTitle(
          padding: const EdgeInsets.all(CustomPageTheme.normalPadding),
          mainText: AppLocalizations.of(context)!.closestToYou,
        secontText: AppLocalizations.of(context)!.more,
         onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (c) => MorePage(storagesClosestToYou!))),
        ),
        storagesRecentlyAdded == null || storagesRecentlyAdded!.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: CustomPageTheme.normalPadding),
                itemCount: storagesClosestToYou!.length,
                //these 2 lines were reponsible for not making the listview
                //keeps crashing
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  height: CustomPageTheme.bigPadding,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Warehouse warehouse = storagesClosestToYou![index];
                  return WarehouseCard(
                    rating: warehouse.rating,
                    id: warehouse.id,
                    governorate: warehouse.city['govName'],
                    district: warehouse.city['name'],
                    title: warehouse.name,
                    discription: warehouse.description,
                    imagePath: warehouse.images[0],
                    price: warehouse.price,
                  );
                },
              ),
      ],
    );
  }
}
