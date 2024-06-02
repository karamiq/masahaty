import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/provider/current_user.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';
import 'circuler_container.dart';

class ProfileHead extends ConsumerStatefulWidget {
  ProfileHead({super.key});

  @override
  ConsumerState<ProfileHead> createState() => _ProfileHeadState();
}

class _ProfileHeadState extends ConsumerState<ProfileHead> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        color: CustomColorsTheme.headLineColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(CoustomBorderTheme.normalBorderRaduis),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -126,
            right: -70,
            child: CirculerContainer(),
          ),
          const Positioned(
            bottom: -80,
            right: -90,
            child: CirculerContainer(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CustomPageTheme.normalPadding,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(Assets.assetsImagesDefultAvatar),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CustomPageTheme.normalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.fullName ?? AppLocalizations.of(context)!.visitor,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: CustomFontsTheme.bigWeight,
                        ),
                      ),
                       Text(
                        currentUser?.shortId ?? AppLocalizations.of(context)!.id,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
