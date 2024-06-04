import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/routes/routes.dart';

import '../../../core/constants/constants.dart';

class AccountSettingDate {
  final BuildContext context;

  AccountSettingDate(this.context);

  void myPosts() => context.pushNamed(Routes.myPostsPage);
  void myBooks() => context.pushNamed(Routes.myBooksPage);
  void myBooksManageMent() => context.pushNamed(Routes.ordersManagementPage);
  void myFavorites() {
    context.pushNamed(Routes.myFavoritesPage);
  }

  List<VoidCallback> get listFunctions => [
        myPosts,
        myBooks,
        myBooksManageMent,
        myFavorites,
      ];
  List<Icon> listLeading = [
    const Icon(Icons.edit_note),
    const Icon(Icons.calendar_today),
    const Icon(Icons.edit_calendar_sharp),
    const Icon(Icons.bookmark_outline_outlined),
  ];
  List<Text> get listTitle => [
        Text(AppLocalizations.of(context)!.myPosts),
        Text(AppLocalizations.of(context)!.myBooking),
        Text(AppLocalizations.of(context)!.orderManagement),
        Text(AppLocalizations.of(context)!.myFavorites),
      ];
  Icon get trailing => const Icon(
        Icons.chevron_right,
      );
}

class ButtonsData {
  final BuildContext context;
  ButtonsData(this.context);

  void createAcount() => context.pushNamed(Routes.registerPage);
  void signIn() => context.pushNamed(Routes.logIn);

  List<ButtonStyle> buttonsStyles = [
    ButtonStyle(
        side: WidgetStateProperty.all(BorderSide.none),
        backgroundColor:
            WidgetStateProperty.all<Color>(CustomColorsTheme.buttonColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CoustomBorderTheme
                .normalBorderRaduis), // Adjust the radius as needed
          ),
        )),
    ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CoustomBorderTheme
                .normalBorderRaduis), // Adjust the radius as needed
          ),
        ),
        side: WidgetStateProperty.all(const BorderSide(
            width: 1.5, color: CustomColorsTheme.headLineColor))),
  ];
  List<VoidCallback> get buttonsFunctions => [
        createAcount,
        signIn,
      ];
  List<Icon> buttonsPrefixIcons = [
    const Icon(Icons.login),
    const Icon(
      Icons.account_box_outlined,
    )
  ];
  List<String> get buttonsText => [
        AppLocalizations.of(context)!.createAccount,
        AppLocalizations.of(context)!.signIn,
      ];
}
