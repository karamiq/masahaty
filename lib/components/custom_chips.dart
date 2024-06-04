import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../core/constants/assets.dart';
import '../core/constants/constants.dart';

class CustomChips extends StatelessWidget {
  const CustomChips({
    super.key,
    required this.featuresChipsPics,
    required this.featuresChipText,
  });

  final List<String> featuresChipsPics;
  final List<String> featuresChipText;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: CoustomBorderTheme.borderWidth,
                  color: CustomColorsTheme.dividerColor),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(featuresChipsPics[index]),
                const SizedBox(
                  width: CustomPageTheme.smallPadding,
                ),
                Text(featuresChipText[index])
              ],
            ),
          );
        }));
  }
}

class CustomChipsData {
  CustomChipsData(this.context);
  late BuildContext context;

  List<String> featuresChipsPics = [
    Assets.assetsIconsCircularCategoriesSafe,
    Assets.assetsIconsCircularCategoriesCooling,
    Assets.assetsIconsCircularCategoriesWide,
  ];
  List<String> get featuresChipText => [
        AppLocalizations.of(context)!.safe,
        AppLocalizations.of(context)!.cooling,
        AppLocalizations.of(context)!.secured,
      ];
}
