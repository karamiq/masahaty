import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:masahaty/provider/change_language.dart';
import 'package:masahaty/provider/notification_statues.dart';
import 'package:masahaty/routes/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    ref.read(currentLanguageProvider.notifier).loadLanguage();
    ref.read(notifsStatusProvider.notifier).loadNotifsStatus();
    return MaterialApp.router(
      scrollBehavior: const ScrollBehavior(),
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      locale: currentLanguage,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColorsTheme.scaffoldBackGroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 101, 132),
              foregroundColor: Colors.white),
        ),
        colorSchemeSeed: const Color.fromARGB(255, 0, 101, 132),
        fontFamily: GoogleFonts.cairo().fontFamily,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
