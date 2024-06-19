import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  //await NotificationController.initializeLocalNotifications();
  //await NotificationController.initializeIsolateReceivePort();
  await SharedPreferences.getInstance();

  // Run the app
  runApp(const ProviderScope(child: MyApp()));
}
////////////////////////////////////////////////////////////////////////////////

// this will be used as notification channel id
const notificationChannelId = 'my_foreground';

// this will be used for notification id, so you can update your custom notification with this id.
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId:
          notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bring to foreground
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(id: 2, channelKey: 'basic_channel',
            title: 'fdlkjssss',body: 'lkfjdsssssssss'));
      }
    }
  });
}

/////////////////////////////////////////////////////////////////////////////////
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
