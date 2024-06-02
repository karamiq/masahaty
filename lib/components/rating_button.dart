import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../routes/routes.dart';

class RatingButton extends ConsumerStatefulWidget {
  const RatingButton({
    super.key,
    required this.warehouseRating,
    required this.id,
  });
  final String id;
  final double warehouseRating;

  @override
  ConsumerState<RatingButton> createState() => _RatingButtonState();
}

class _RatingButtonState extends ConsumerState<RatingButton> {
  get currentUserToken => ref.read(currentUserProvider)?.token;
  bool isLoading = false;

  final storageService = StorageService();

  void signIn() => context.pushNamed(Routes.logIn);

  @override
  Widget build(BuildContext context) {
    double rating = 1;
    Future<void> rate() async {
      setState(() {
        isLoading = true;
      });
      await storageService.storageRate(
          token: currentUserToken, rate: rating, id: widget.id);
      context.pop();
      setState(() {
        isLoading = false;
      });
      print(rating);
    }

    return Container(
      width: 68,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          CoustomBorderTheme.normalBorderRaduis,
        ),
        color: Colors.white.withOpacity(.9),
      ),
      child: TextButton(
        onPressed: () {
          print('fffffff');
          showDialog(
              context: context,
              builder: (context) => ModalProgressHUD(
                    inAsyncCall: isLoading,
                    child: AlertDialog(
                      backgroundColor:
                          CustomColorsTheme.scaffoldBackGroundColor,
                      contentPadding:
                          const EdgeInsets.all(CustomPageTheme.bigPadding),
                      content: currentUserToken != null
                          ? SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: CustomPageTheme.veryBigpadding,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.ratingText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: CustomFontsTheme.bigWeight,
                                        fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height:
                                        CustomPageTheme.veryBigpadding * 1.5,
                                  ),
                                  RatingBar.builder(
                                      itemBuilder: (context, index) {
                                        return const Icon(
                                          Icons.star,
                                          color: CustomColorsTheme.starColor,
                                        );
                                      },
                                      glowColor: CustomColorsTheme.starColor,
                                      initialRating: 1,
                                      tapOnlyMode: true,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal:
                                              CustomPageTheme.smallPadding),
                                      onRatingUpdate: (newRating) {
                                        rating = newRating;
                                      }),
                                  const SizedBox(
                                    height: CustomPageTheme.bigPadding,
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                CoustomBorderTheme
                                                    .normalBorderRaduis))),
                                    onPressed: rate,
                                    child: Text(
                                        AppLocalizations.of(context)!.send),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
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
                      //width: 30,
                      decoration: BoxDecoration(
                          color: CustomColorsTheme.headLineColor,
                          shape: BoxShape.circle),
                      child: const Icon(
                        size: 50,
                        Icons.login,
                        color: Colors.white,
                      )),
                                  const SizedBox(height: CustomPageTheme.veryBigpadding,),
                                  OutlinedButton.icon(
                                      style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(CoustomBorderTheme
                                                      .normalBorderRaduis), // Ad
                                            ),
                                          ),
                                          side: WidgetStateProperty.all(
                                              const BorderSide(
                                                  width: 1.5,
                                                  color: CustomColorsTheme
                                                      .headLineColor))),
                                      onPressed: signIn,
                                      label: Text(
                                          AppLocalizations.of(context)!.signIn),
                                      icon: const Icon(
                                        Icons.account_box_outlined,
                                      ))
                                 
                                ],
                              ),
                            ),
                    ),
                  ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('(${widget.warehouseRating})'),
            const Spacer(),
            const Icon(
              Icons.star,
              color: CustomColorsTheme.starColor,
              size: CoustomIconTheme.verySmallize,
            ),
          ],
        ),
      ),
    );
  }
}
