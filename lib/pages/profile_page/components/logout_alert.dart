
  import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/constants.dart';
import '../../../provider/current_user.dart';

Future<dynamic> logoutAlert(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  Container(
                      height: 70,
                      width: 70,
                      //width: 30,
                      decoration: BoxDecoration(
                          color: CustomColorsTheme.unAvailableRadioColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        size: 50,
                        Icons.logout_rounded,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.logoutDiscription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style:  TextButton.styleFrom(
                        backgroundColor: CustomColorsTheme.unAvailableRadioColor
                      ),
                        onPressed: ()  {
                      ref
                          .watch(currentUserProvider.notifier)
                          .logOutCurrentUser();
                          context.pop();
                    },
                        child:
                            Text(AppLocalizations.of(context)!.logoutAnyway)),
                  ),
                ],
              ),
            ),
          ));
  }