import 'dart:async';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:masahaty/core/constants/assets.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/routes/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      context.go(Routes.gettingStated);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 0, 158, 204),
            Color.fromARGB(255, 1, 78, 102),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(CustomPageTheme.veryBigpadding),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: CustomPageTheme.meduimPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Expanded(
                    child: Center(
                      child: Center(
                        child: AnimatedGlow(),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        AppLocalizations.of(context)!.allRightsAreSaved,
                        style: const TextStyle(
                            color: Color(0xFF80ACB9),
                            fontSize: CustomFontsTheme.meduimSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedGlow extends StatefulWidget {
  const AnimatedGlow({super.key});

  @override
  _AnimatedGlowState createState() => _AnimatedGlowState();
}

class _AnimatedGlowState extends State<AnimatedGlow>
    with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: Container(
          margin: const EdgeInsets.all(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.assetsIconsAppLogo),
              const SizedBox(
                width: 10,
              ),
              Text(
                AppLocalizations.of(context)!.masahaty,
                style: const TextStyle(
                    fontWeight: CustomFontsTheme.bigWeight,
                    fontSize: RandomStuffTheme.logoSize,
                    color: Colors.white),
              )
            ],
          )),
      builder: (context, child) {
        return CustomPaint(
          painter: GlowingThing(
            value: controller.value,
          ),
          child: child,
        );
      },
    );
  }
}

class GlowingThing extends CustomPainter {
  GlowingThing({required this.value, super.repaint});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, lerpDouble(5, 10, value)!);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(25)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
