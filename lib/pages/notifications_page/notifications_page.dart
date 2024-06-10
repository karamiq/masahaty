import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/components/viewed_item_title.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/models/notifications_model.dart';
import 'package:masahaty/provider/change_language.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_notifications.dart';
import 'package:masahaty/services/dio_order.dart';
import 'components/empty_notifications.dart';
import 'components/error_notifications.dart';
import 'components/has_data_notifications.dart';
import 'components/notifications_skeleton.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});
  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  get currentLanguage => ref.read(currentLanguageProvider);
  dynamic token;
  OrderService orderService = OrderService();
  List<Notif>? previousNotifs;
  Set<String> previousIds = {};
  Future<List<Notif>> getNotifications() async {
    NotificationsService notificationsService = NotificationsService();
    List<Notif> temp = token != null
        ? await notificationsService.notificationsGet(token: token!)
        : [];
    previousNotifs = temp;
    return temp;
  }

  @override
  void initState() {
    super.initState();
    token = ref.read(currentUserProvider)?.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: CustomPageTheme.normalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: CustomPageTheme.bigPadding,
              ),
              FutureBuilder<List<Notif>>(
                future: getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: NotificationsSkeleton(),
                    );
                  } else if (snapshot.hasError) {
                    return ErrorNotifications(
                      snapshot: snapshot,
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const EmptyNotifications();
                  } else if (snapshot.hasData) {
                    List<Notif> notifications = snapshot.data!;
                    List<Notif> todayNotifications = [];
                    List<Notif> previousNotifications = [];
                    DateTime today = DateTime.now().toLocal();
                    for (var notification in notifications) {
                      if (notification.creationDate.day == today.day &&
                          notification.creationDate.month == today.month &&
                          notification.creationDate.year == today.year) {
                        todayNotifications.add(notification);
                      } else {
                        previousNotifications.add(notification);
                      }
                    }
                    previousNotifs = previousNotifications;
                    return HasDataNotifications(
                        todayNotifications: todayNotifications,
                        currentLanguage: currentLanguage,
                        previousNotifications: previousNotifications);
                  } else {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                },
              ),
              const SizedBox(
                height: CustomPageTheme.normalPadding,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildNotificationItem(
    {required BuildContext context,
    required Notif notification,
    required dynamic currentLanguage,
    required String dateForm}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: CoustomBorderTheme.borderWidth,
              color: CustomColorsTheme.dividerColor),
          borderRadius:
              BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis),
        ),
        child: ListTile(
          title: Text(notification.title),
          subtitle: Text(
            notification.description,
          ),
          leading: const CircleAvatar(),
          trailing: Column(
            children: [
              Text(DateFormat(dateForm, currentLanguage.languageCode)
                  .format(notification.creationDate))
            ],
          ),
        ),
      ),
    ],
  );
}
