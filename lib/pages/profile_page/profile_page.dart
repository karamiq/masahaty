import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masahaty/components/viewed_item_title.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/pages/profile_page/components/profie_elements_data.dart';
import 'package:masahaty/provider/change_language.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/provider/notification_statues.dart';
import '../../components/form_container.dart';
import '../../components/padded_divider.dart';
import 'components/logout_alert.dart';
import 'components/profile_head.dart';
import 'components/settings_buttons.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Locale? selectedLanguage;
  bool? notifications;

  void newLang() => ref
      .read(currentLanguageProvider.notifier)
      .changeLanguage(selectedLanguage!);

  void newNotifsStatus() => ref
      .read(notifsStatusProvider.notifier)
      .changeNotifsStatues(notifications!);

  void logout() => logoutAlert(context, ref);
  
  @override
  Widget build(BuildContext context) {
    selectedLanguage = ref.watch(currentLanguageProvider);
    notifications = ref.watch(notifsStatusProvider);
    final currentUser = ref.read(currentUserProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHead(),
              const SizedBox(
                height: CustomPageTheme.normalPadding,
              ),
              ViewedItemsTitle(mainText: AppLocalizations.of(context)!.settings),
              const SizedBox(
                height: CustomPageTheme.normalPadding,
              ),
              FormContainer(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: Text(
                      AppLocalizations.of(context)!.notifications,
                    ),
                    trailing: Switch(
                      value: notifications!,
                      onChanged: (value) {
                        setState(() {
                          notifications = value;
                        });
                        newNotifsStatus();
                      },
                    ),
                  ),
                  const PaddedDivider(),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(
                      AppLocalizations.of(context)!.language,
                    ),
                    trailing: DropdownButton<Locale>(
                      value: selectedLanguage,
                      style: TextStyle(
                        color: CustomColorsTheme.descriptionColor,
                        fontFamily: GoogleFonts.cairo().fontFamily,
                      ),
                      underline: Container(),
                      onChanged: (Locale? newValue) {
                        setState(() {
                          selectedLanguage = newValue!;
                        });
                        newLang();
                      },
                      items: [
                        DropdownMenuItem(
                          value: const Locale('ar'),
                          child: Text(AppLocalizations.of(context)!.arabic),
                        ),
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: Text(AppLocalizations.of(context)!.english),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: CustomPageTheme.bigPadding,
              ),
              ViewedItemsTitle(mainText: AppLocalizations.of(context)!.account),
              const SizedBox(
                height: CustomPageTheme.normalPadding,
              ),
              FormContainer(
                children: [
                  ListView.separated(
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const PaddedDivider(),
                    itemBuilder: (context, index) => ListTile(
                        onTap: AccountSettingDate(context).listFunctions[index],
                        leading: AccountSettingDate(context).listLeading[index],
                        title: AccountSettingDate(context).listTitle[index],
                        trailing: AccountSettingDate(context).trailing),
                  ),
                ],
              ),
              const SizedBox(
                height: CustomPageTheme.bigPadding,
              ),
              if (currentUser == null)
                SettingsButtons(
                    buttonsStyles: ButtonsData(context).buttonsStyles,
                    buttonsFunctions: ButtonsData(context).buttonsFunctions,
                    buttonsPrefixIcons: ButtonsData(context).buttonsPrefixIcons,
                    buttonsText: ButtonsData(context).buttonsText),
              if (currentUser != null)
                SettingsButtons(suffixIcon: const Icon(null), buttonsStyles: [
                  ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          CustomColorsTheme.unAvailableRadioColor),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              CoustomBorderTheme.normalBorderRaduis),
                        ),
                      ),
                      side: WidgetStateProperty.all(const BorderSide(
                          width: 1.5,
                          color: CustomColorsTheme.unAvailableRadioColor))),
                ], buttonsFunctions: [
                  logout
                ], buttonsPrefixIcons: const [
                  Icon(Icons.logout)
                ], buttonsText: [
                  AppLocalizations.of(context)!.logout
                ]),
            ],
          ),
        ),
      ),
    );
  }
}
