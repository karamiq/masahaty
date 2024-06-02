import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CitiesManagement {
  late BuildContext context;
  CitiesManagement(this.context);

  get _localized => AppLocalizations.of(context)!;

  Map<String, String> get baghdadCities => {
        _localized.alAdhamiya: _localized.alAdhamiya,
        _localized.alAmin: _localized.alAmin,
        _localized.alBaladiyat: _localized.alBaladiyat,
        _localized.alBayaa: _localized.alBayaa,
        _localized.alJadriya: _localized.alJadriya,
        _localized.alKadhimiya: _localized.alKadhimiya,
        _localized.alKarkh: _localized.alKarkh,
        _localized.alKarrada: _localized.alKarrada,
        _localized.alMansour: _localized.alMansour,
        _localized.alSadrCity: _localized.alSadrCity,
        _localized.alShaab: _localized.alShaab,
        _localized.alThawraCity: _localized.alThawraCity,
        _localized.babAlMuadham: _localized.babAlMuadham,
        _localized.babAlSharqi: _localized.babAlSharqi,
        _localized.babAlSheikh: _localized.babAlSheikh,
        _localized.hayyAlJamia: _localized.hayyAlJamia,
        _localized.hayyAlShuhada: _localized.hayyAlShuhada,
        _localized.hayyUr: _localized.hayyUr,
        _localized.karradatMaryam: _localized.karradatMaryam,
        _localized.alGhazaliyah: _localized.alGhazaliyah,
      };

  late Map<String, Map<String, String>> cities = {
    _localized.baghdad: baghdadCities,
    _localized.dohuk: dohukCities,
    _localized.erbil: erbilCities,
    _localized.alSulaymaniyah: alSulaymaniyahCities,
    _localized.kirkuk: kirkukCities,
    _localized.nineveh: ninevehCities,
    _localized.alAnbar: alAnbarCities,
    _localized.saladin: saladinCities,
    _localized.diyala: diyalaCities,
    _localized.babil: babilCities,
    _localized.karbala: karbalaCities,
    _localized.alNajaf: alNajafCities,
    _localized.alMuthanna: alMuthannaCities,
    _localized.alQadisiyyah: alQadisiyyahCities,
    _localized.halabja: halabjaCities,
    _localized.wasit: wasitCities,
    _localized.basra: basraCities,
    _localized.maysan: maysanCities,
    _localized.dhiQar: dhiQarCities,
  };

  Map<String, String> get dohukCities => {};
  Map<String, String> get erbilCities => {};
  Map<String, String> get alSulaymaniyahCities => {};
  Map<String, String> get kirkukCities => {};
  Map<String, String> get ninevehCities => {};
  Map<String, String> get alAnbarCities => {};
  Map<String, String> get saladinCities => {};
  Map<String, String> get diyalaCities => {};
  Map<String, String> get babilCities => {};
  Map<String, String> get karbalaCities => {};
  Map<String, String> get alNajafCities => {};
  Map<String, String> get alMuthannaCities => {};
  Map<String, String> get alQadisiyyahCities => {};
  Map<String, String> get halabjaCities => {};
  Map<String, String> get wasitCities => {};
  Map<String, String> get basraCities => {};
  Map<String, String> get maysanCities => {};
  Map<String, String> get dhiQarCities => {};

  Map<String, String> get citiesForApi => {
     _localized.alAdhamiya:"الأعظمية",
        _localized.alAmin: "الأمين",
        _localized.alBaladiyat:   "البلديات",
        _localized.alBayaa:  "البياع",
        _localized.alJadriya:  "الجادرية",
        _localized.alKadhimiya: "الكاظمية",
        _localized.alKarkh:    "الكرخ",
        _localized.alKarrada: "الكرادة",
        _localized.alMansour:  "المنصور",
        _localized.alSadrCity:  "مدينة الصدر",
        _localized.alShaab:  "الشعب",
        _localized.alThawraCity:  "مدينة الثورة",
        _localized.babAlMuadham:"باب المعظم",
        _localized.babAlSharqi:   "باب الشرقي",
        _localized.babAlSheikh:   "باب الشيخ",
        _localized.hayyAlJamia:  "حي الجامعة",
        _localized.hayyAlShuhada: "حي الشهداء",
        _localized.hayyUr: "حي العروبة",
        _localized.karradatMaryam:  "مريم الكرادة",
        _localized.alGhazaliyah:  "الغزالية",
  };
}
