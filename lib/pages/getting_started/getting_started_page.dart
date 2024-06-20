import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/provider/change_language.dart';
import '../../routes/routes.dart';
import 'components/slides_data.dart';

class GettingStarted extends ConsumerStatefulWidget {
  const GettingStarted({super.key});

  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends ConsumerState<GettingStarted> {
  @override
  Widget build(BuildContext context) {
    final currrentLanguage = ref.read(currentLanguageProvider);

    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        flex: 17,
        child: CarouselSlider(
            options: CarouselOptions(
              enlargeFactor: .3,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              reverse: false,
              height: MediaQuery.of(context).size.height,
            ),
            items: List.generate(
              3,
              (slidesIndex) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 586,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 0, 158, 204),
                              Color.fromARGB(255, 0, 101, 132),
                            ]),
                        borderRadius: currrentLanguage == const Locale('en')
                            ? SlidesData(context).borderRadiusListAR[slidesIndex]
                            : SlidesData(context).borderRadiusListEN[slidesIndex],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                              SlidesData(context).picSlidesList[slidesIndex]),
                          const SizedBox(
                            height: CustomPageTheme.meduimPadding,
                          ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) => 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: AnimatedContainer(
                                curve: Curves.easeIn,
                                duration: const Duration(microseconds: 500),
                                width: slidesIndex == index ? 30 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)
                              
                                ),
                              ),
                            )
                          
                          ),
                         )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SlidesData(context).textTitleList[slidesIndex],
                            style: const TextStyle(
                              color: CustomColorsTheme.headLineColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 45,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            SlidesData(context).textSubtitleList[slidesIndex],
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            SlidesData(context).textDiscriptionList[slidesIndex],
                            style: const TextStyle(
                              color: CustomColorsTheme.descriptionColor,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            )),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        CoustomBorderTheme.normalBorderRaduis))
                //backgroundColor: Color.fromARGB(255, 0, 101, 132),
                ),
            onPressed: () => context.go(Routes.tabsPage),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.startYourJurny),
                const Icon(
                  Icons.chevron_right,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 16,
      ),
    ]));
  }
}
