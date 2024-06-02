
  import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../core/constants/assets.dart';


class SlidesData {
  
  final BuildContext context;

  SlidesData(this.context);


  
  final List<String> picSlidesList = [
    Assets.assetsImagesGettingStartedPic1,
    Assets.assetsImagesGettingStartedPic2,
    Assets.assetsImagesGettingStartedPic3
  ];
  List get borderRadiusListAR => [
    const BorderRadius.only(bottomLeft: Radius.circular(150)),
    const BorderRadius.vertical(bottom: Radius.circular(150)),
    const BorderRadius.only(bottomRight: Radius.circular(150)),
  ];
  List get borderRadiusListEN => [
    const BorderRadius.only(bottomRight: Radius.circular(150)),
    const BorderRadius.vertical(bottom: Radius.circular(150)),
    const BorderRadius.only(bottomLeft: Radius.circular(150)),
  ];
  List<String> get textTitleList => [
    AppLocalizations.of(context)!.welcom,
    AppLocalizations.of(context)!.keepYourThings,
    AppLocalizations.of(context)!.readyToServeYou,
  ];
  List<String> get textSubtitleList => [
    AppLocalizations.of(context)!.welcomIn,
    AppLocalizations.of(context)!.easyAndNoSuffring,
    AppLocalizations.of(context)!.helpYouStoreYourStuff
  ];
  List<String> get textDiscriptionList => [
    AppLocalizations.of(context)!.firstAppInIraq,
    AppLocalizations.of(context)!.keepYourThingsDiscription,
    AppLocalizations.of(context)!.readyToServeYouDiscription,
  ];
}