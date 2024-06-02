
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';

class CategoriesSequareTypes extends StatelessWidget {
  const CategoriesSequareTypes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> categoriesTitle = [
      AppLocalizations.of(context)!.safe,
      AppLocalizations.of(context)!.cooling,
      AppLocalizations.of(context)!.external,
      AppLocalizations.of(context)!.small,
      AppLocalizations.of(context)!.wide,
    ];
    final List<String> categoriesPics = [
    Assets.assetsIconsBoxCategoriesSafe,
    Assets.assetsIconsBoxCategoriesCooling,
    Assets.assetsIconsBoxCategoriesExternal,
    Assets.assetsIconsBoxCategoriesSmall,
    Assets.assetsIconsBoxCategoriesWide,
  ];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        itemCount: categoriesPics.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    CoustomBorderTheme.normalBorderRaduis),
                border: Border.all(color: Colors.grey, width: 0.1),
              ),
              height: 97,
              width: 102,
              child: Padding(
                padding: const EdgeInsets.all(CustomPageTheme.smallPadding),
                child: Column(children: [
                  SvgPicture.asset(categoriesPics[index]),
                  Text(
                    categoriesTitle[index],
                    style:
                        const TextStyle(fontSize: CustomFontsTheme.bigSize),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}