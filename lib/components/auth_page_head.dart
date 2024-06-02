
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masahaty/components/custom_back_botton.dart';

import '../core/constants/assets.dart';
import '../core/constants/constants.dart';
import '../pages/profile_page/components/circuler_container.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PageHead extends StatelessWidget {
  const PageHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              height: 200, width: double.infinity,
              decoration: const BoxDecoration(
                color: CustomColorsTheme.headLineColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(CoustomBorderTheme.normalBorderRaduis),
                  bottomRight: Radius.circular(CoustomBorderTheme.normalBorderRaduis)
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.assetsIconsAppLogo),
                  const SizedBox(width: 10,),
                  Text(AppLocalizations.of(context)!.masahaty,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: CustomFontsTheme.bigWeight,
                      fontSize: RandomStuffTheme.logoSize
                    ),
                  )
                ],
              ),
            ),
             const Positioned(right: -130,height:  200   ,child: CirculerContainer()),
             const Positioned(right: -80, bottom: -100    ,child: CirculerContainer()),
             const Positioned(left: -130, height:  200    ,child: CirculerContainer()),
             const Positioned(left: -80,  bottom: -100    ,child: CirculerContainer()),
          ],
        ),     
         const Padding(
           padding: EdgeInsets.symmetric(horizontal: CustomPageTheme.normalPadding ,vertical:  CustomPageTheme.meduimPadding *1.5),
           child: customBackButton(),
         ),    
      ],
    );
  }
}