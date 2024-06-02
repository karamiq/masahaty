
import 'package:flutter/material.dart';
import 'package:masahaty/pages/wharehouse_pages/components/detailes_table_row.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../core/constants/constants.dart';

class InfoTable extends StatelessWidget {
  const InfoTable({super.key,
  required this.currentLanguage,
  required this.currentWarehouse,
   required this.features,
   });
  final currentLanguage;
  final currentWarehouse;
  final List<Map<String, dynamic>> features; 
  @override
  Widget build(BuildContext context) {
    Text findFeatureWidget(String featureName) {
      Map<String, dynamic> feature = features.firstWhere(
        (feature) => feature['name'] == featureName,
        orElse: () => {"name": "", "id": ""},
      );

      if (feature.isNotEmpty && feature["name"] == featureName) {
        return Text(
          AppLocalizations.of(context)!.avialble,
          style: const TextStyle(
            color: CustomColorsTheme.availableRadioColor,
            fontSize: CustomFontsTheme.bigSize,
          ),
        );
      } else {
        return Text(
          AppLocalizations.of(context)!.notAvailble,
          style: const TextStyle(
            color: CustomColorsTheme.unAvailableRadioColor,
            fontSize: CustomFontsTheme.bigSize,
          ),
        );
      }
    }
    return Column(
      children: [
        DetailsTableRow(
            borderRadius: currentLanguage == const Locale('ar')
                ? const BorderRadius.only(
                    topRight:
                        Radius.circular(CoustomBorderTheme.normalBorderRaduis))
                : const BorderRadius.only(
                    topLeft:
                        Radius.circular(CoustomBorderTheme.normalBorderRaduis)),
            titelIcon: const Icon(
              Icons.view_in_ar,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
            titelText: AppLocalizations.of(context)!.space,
            currentLanguage: currentLanguage,
            titleIfo: Text(currentWarehouse!.space.toString())),
        DetailsTableRow(
            titelIcon: const Icon(
              Icons.house_outlined,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
            titelText: AppLocalizations.of(context)!.numberOfRooms,
            currentLanguage: currentLanguage,
            titleIfo: Text(currentWarehouse!.numberOfRooms.toString())),
        DetailsTableRow(
            titelIcon: const Icon(
              Icons.camera,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
            titelText: AppLocalizations.of(context)!.camera,
            currentLanguage: currentLanguage,
            titleIfo: findFeatureWidget('كاميرات')),
        DetailsTableRow(
            titelIcon: const Icon(
              Icons.air,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
            titelText: AppLocalizations.of(context)!.cooling,
            currentLanguage: currentLanguage,
            titleIfo: findFeatureWidget('مكيفة')),
        DetailsTableRow(
            titelIcon: const Icon(
              Icons.roofing,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
            titelText: AppLocalizations.of(context)!.roof,
            currentLanguage: currentLanguage,
            titleIfo: findFeatureWidget('سقف')),
        DetailsTableRow(
            titelIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
            titelText: AppLocalizations.of(context)!.safe,
            currentLanguage: currentLanguage,
            titleIfo: findFeatureWidget('مؤمنة')),
        DetailsTableRow(
          titelIcon: const Icon(
            Icons.shield_outlined,
            color: Color.fromARGB(150, 0, 0, 0),
          ),
          titelText: AppLocalizations.of(context)!.secured,
          currentLanguage: currentLanguage,
          titleIfo: findFeatureWidget('حراسة'),
          borderRadius: currentLanguage == const Locale('ar')
              ? const BorderRadius.only(
                  bottomRight:
                      Radius.circular(CoustomBorderTheme.normalBorderRaduis))
              : const BorderRadius.only(
                  bottomLeft:
                      Radius.circular(CoustomBorderTheme.normalBorderRaduis)),
        ),
      ],
    );
  }
}
