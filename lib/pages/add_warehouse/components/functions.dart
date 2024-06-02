import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/services/dio_files.dart';
import '../../../services/dio_features.dart';
import '../../../services/dio_govs&cities.dart';
import 'cities_management.dart';

final govs = Govs();
Future<String?> getGovId(BuildContext context, String gov) async {
  Map<String, String> govss = {
    AppLocalizations.of(context)!.baghdad: 'بغداد',
    AppLocalizations.of(context)!.dohuk: 'دهوك',
    AppLocalizations.of(context)!.erbil: 'أربيل',
    AppLocalizations.of(context)!.alSulaymaniyah: 'السليمانية',
    AppLocalizations.of(context)!.kirkuk: 'كركوك',
    AppLocalizations.of(context)!.nineveh: 'نينوى',
    AppLocalizations.of(context)!.alAnbar: 'الأنبار',
    AppLocalizations.of(context)!.saladin: 'صلاح الدين',
    AppLocalizations.of(context)!.diyala: 'ديالى',
    AppLocalizations.of(context)!.babil: 'بابل',
    AppLocalizations.of(context)!.karbala: 'كربلاء',
    AppLocalizations.of(context)!.alNajaf: 'النجف',
    AppLocalizations.of(context)!.alMuthanna: 'المثنى',
    AppLocalizations.of(context)!.alQadisiyyah: 'القادسية',
    AppLocalizations.of(context)!.halabja: 'حلبجة',
    AppLocalizations.of(context)!.wasit: 'واسط',
    AppLocalizations.of(context)!.basra: 'البصرة',
    AppLocalizations.of(context)!.maysan: 'ميسان',
    AppLocalizations.of(context)!.dhiQar: 'ذي قار',
  };
  if (govss.containsKey(gov)) {
    final cuurentGov = govss[gov];
    return await govs.govGet(cuurentGov!);
  }
  return null;
}

final cities = Cities();
Future<Map<String,dynamic>?> getCityId(BuildContext context, String city, String gov) async {
  final allCities = CitiesManagement(context).citiesForApi;
  if (allCities.containsKey(city)) {
    String? s = allCities[city];
    return await cities.cityGet(s);
  }
  return null;
}

final featuresService = FeaturesService();
Future<List<String>> getFeaturesIds({
  required cooling,
  required roof,
  required garuded,
  required safe,
  required securityCameras,
}) async {
  List<String> temp = [];
  if (cooling) {
    String coolingId = await featuresService.featuresGet('مكيفة');
    temp.add(coolingId);
  }
  if (roof) {
    String roofId = await featuresService.featuresGet('سقف');
    temp.add(roofId);
  }
  if (garuded) {
    String gurderdId = await featuresService.featuresGet('حراسة');
    temp.add(gurderdId);
  }
  if (safe) {
    String safeId = await featuresService.featuresGet('خزنة');
    temp.add(safeId);
  }
  if (securityCameras) {
    String securityCamerasId = await featuresService.featuresGet('كاميرات');
    temp.add(securityCamerasId);
  }
  return temp;
}

final filesService = FileService();
Future<List<String>> uploadImages(List<File> images, String token) async {
  final temp = filesService.multipleFiles(images: images, token: token);
  return temp;
}

Map<String, String> getCities(BuildContext context, String currentGov) {
  final citiesManagement = CitiesManagement(context);
  Map<String, Map<String, String>> city = citiesManagement.cities;
  Map<String, String> temp = {};
  city.forEach((key, value) {
    if (key == currentGov) {
      temp = value;
    }
  });
  return temp;
}
