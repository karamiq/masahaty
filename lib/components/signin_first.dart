
  import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../core/constants/constants.dart';
import '../routes/routes.dart';

SizedBox SignInFirst(BuildContext context) {
    return SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.signInFirst,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: CustomFontsTheme.bigWeight,
                              fontSize: 25),
                        ),
                        Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                                color: CustomColorsTheme.headLineColor,
                                shape: BoxShape.circle),
                            child: const Icon(
                              size: 50,
                              Icons.login,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          height: CustomPageTheme.veryBigpadding,
                        ),
                        OutlinedButton.icon(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        CoustomBorderTheme
                                            .normalBorderRaduis), // Ad
                                  ),
                                ),
                                side: WidgetStateProperty.all(
                                    const BorderSide(
                                        width: 1.5,
                                        color: CustomColorsTheme
                                            .headLineColor))),
                            onPressed: ()=>context.pushNamed(Routes.logIn),
                            label: Text(AppLocalizations.of(context)!.signIn),
                            icon: const Icon(
                              Icons.account_box_outlined,
                            ))
                      ],
                    ),
                  );
  }