import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:workmanager/workmanager.dart';

import 'services/dio_notifications.dart';
import 'services/notifications_handlers.dart';

void main() async {
  // Initialize Flutter Awesome Notifications
  await AwesomeNotifications().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Main Channels',
        channelDescription: "A notification channel for notifications",
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "basic_channel_group",
        channelGroupName: 'another basic group',
      ),
    ],
  );
  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowedToSendNotifications) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  await SharedPreferences.getInstance();

  // Run the app
  runApp(const ProviderScope(child: MyApp()));
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Call your NotificationsService here
    final token = inputData?['token'];
    await NotificationsService().notificationsGet(token: token);
    return Future.value(true);
  });
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
