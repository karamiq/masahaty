import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';

class HomePageBar extends StatefulWidget {
  const HomePageBar(
      {super.key,
      required this.userName,
      required this.id,
      required,
      required this.district,
      required this.governorate,
      required this.onTap});
  final dynamic district;
  final dynamic governorate;
  final String userName;
  final String id;
  final Function()? onTap;

  @override
  State<HomePageBar> createState() => _HomePageBarState();
}

class _HomePageBarState extends State<HomePageBar> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: CustomPageTheme.bigPadding * 2,bottom:CustomPageTheme.bigPadding , right: CustomPageTheme.bigPadding, left: CustomPageTheme.bigPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Image.asset(Assets.assetsImagesDefultAvatar),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontWeight: CustomFontsTheme.bigWeight,
                      ),
                    ),
                    Text(widget.id),
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            borderRadius:
                BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              try {
                await widget.onTap!();
              } catch (e) {
                print(e);
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 35,
                        color: CustomColorsTheme.headLineColor,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.yourCurrentLocation,
                            style: const TextStyle(
                              color: CustomColorsTheme.descriptionColor,
                              fontSize: CustomFontsTheme.normalSize,
                            ),
                          ),
                          Row(
                            children: [
                              Text('${widget.governorate}-${widget.district}'),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 30,
                                color: CustomColorsTheme.headLineColor,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/*

        Row(
          children: [
            Row(
              children: [
                CircleAvatar(
          radius: 28,
          child: Image.asset(Assets.assetsImagesDefultAvatar),
        ),
        const SizedBox(width: CoustomPageTheme.smallPadding),
        Column(
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontWeight: CoustomFontsTheme.bigWeight,
              ),
            ),
             Text(id),
          ],
        ),
              ],
            ),
            
        const Icon(Icons.location_on_outlined, color: CoustomColorsTheme.headLineColor,),
        Column(
          children: [
            Text(AppLocalizations.of(context)!.yourCurrentLocation),
            Row(
              children: [
                Text('$governorate-$district'),
                const Icon(Icons.dock_rounded, size: 10),
              ],
            )
          ],
        ),
             
          
          ],
        )


*/