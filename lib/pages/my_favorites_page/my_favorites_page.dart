import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/components/custom_back_botton.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/models/warehouse_model.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/provider/user_favorites.dart';
import '../../components/warehouse_card.dart';

class MyFavoritesPage extends ConsumerWidget {
  const MyFavoritesPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    print(favorites);
    List<Warehouse> currentFavorites = favorites;
    Widget content;
    if (currentFavorites.isEmpty) {
      content = Center(
        child: Text(AppLocalizations.of(context)!.myFavorites),
      );
    } else {
      content = ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: CustomPageTheme.normalPadding),
        itemCount: currentFavorites.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: CustomPageTheme.normalPadding,
        ),
        itemBuilder: (context, index) {
          if (currentFavorites.isEmpty) {
            return Center(child: const Text('em'));
          } else {
            return WarehouseCard(
                rating: currentFavorites[index].rating,
                id: currentFavorites[index].id,
                governorate: currentFavorites[index].city['govName'],
                district: currentFavorites[index].city['name'],
                title: currentFavorites[index].name,
                discription: currentFavorites[index].description,
                imagePath: currentFavorites[index].images[0],
                price: currentFavorites[index].price);
          }
        },
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColorsTheme.scaffoldBackGroundColor,
          leading: const Padding(
            padding: EdgeInsets.all(CustomPageTheme.smallPadding),
            child: customBackButton(),
          ),
        ),
        body: content);
  }
}
