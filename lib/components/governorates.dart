
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class IraqiGoveronates {
  final BuildContext context;
  IraqiGoveronates(this.context);
 

  Map<String,String> get iraqStates => {
    AppLocalizations.of(context)!.baghdad: AppLocalizations.of(context)!.baghdad,
    AppLocalizations.of(context)!.dohuk: AppLocalizations.of(context)!.dohuk,
    AppLocalizations.of(context)!.erbil: AppLocalizations.of(context)!.erbil,
    AppLocalizations.of(context)!.alSulaymaniyah: AppLocalizations.of(context)!.alSulaymaniyah,
    AppLocalizations.of(context)!.kirkuk: AppLocalizations.of(context)!.kirkuk,
    AppLocalizations.of(context)!.nineveh: AppLocalizations.of(context)!.nineveh,
    AppLocalizations.of(context)!.alAnbar: AppLocalizations.of(context)!.alAnbar,
    AppLocalizations.of(context)!.saladin: AppLocalizations.of(context)!.saladin,
    AppLocalizations.of(context)!.diyala: AppLocalizations.of(context)!.diyala,
    AppLocalizations.of(context)!.babil: AppLocalizations.of(context)!.babil,
    AppLocalizations.of(context)!.karbala: AppLocalizations.of(context)!.karbala,
    AppLocalizations.of(context)!.alNajaf: AppLocalizations.of(context)!.alNajaf,
    AppLocalizations.of(context)!.alMuthanna: AppLocalizations.of(context)!.alMuthanna,
    AppLocalizations.of(context)!.alQadisiyyah: AppLocalizations.of(context)!.alQadisiyyah,
    AppLocalizations.of(context)!.halabja:AppLocalizations.of(context)!.halabja,
    AppLocalizations.of(context)!.wasit:AppLocalizations.of(context)!.wasit,
    AppLocalizations.of(context)!.basra:AppLocalizations.of(context)!.basra,
    AppLocalizations.of(context)!.maysan:AppLocalizations.of(context)!.maysan,
    AppLocalizations.of(context)!.dhiQar:AppLocalizations.of(context)!.dhiQar,
  };
}