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
import 'components/notifications_skeleton.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});
  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  get currentLanguage => ref.read(currentLanguageProvider);
  get token => ref.read(currentUserProvider)?.token;
  OrderService orderService = OrderService();
   List<Notif>? previousNotifs;
  Set<String> previousIds = Set();
   Future<List<Notif>> getNotifications() async {
    NotificationsService notificationsService = NotificationsService();
    List<Notif> temp = token != null
        ? await notificationsService.notificationsGet(token: token!)
        : [];

    previousNotifs = temp;
    return temp;
  }

   Future<void> checkForNewNotifications() async {
    while (true) {
      List<Notif> newNotifications = await getNotifications();
      if (newNotifications.isNotEmpty) {
        newNotifications.forEach((notif) {
          if (!previousIds.contains(notif.id)) {
            print("New notification: ${notif.title}");
            print("Description: ${notif.description}");
            previousIds.add(notif.id);
          }
        });
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  @override
  void initState() {
    super.initState();
    checkForNewNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: CustomPageTheme.normalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    AwesomeNotifications().createNotification(
                        content: NotificationContent(
                      id: 1,
                      channelKey: "basic_channel",
                      title: 'Hello karam',
                      body: "yess yes yes",
                    ));
                  },
                  child: const Text('')),
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
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Column(
                      children: [
                        Text(
                            "${AppLocalizations.of(context)!.notifications} ${AppLocalizations.of(context)!.empty}"),
                      ],
                    );
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
                    if (previousNotifs != null &&
                        previousNotifications.length > previousNotifs!.length) {
                      Notif newNotification = previousNotifications.last;

                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: previousNotifications.length,
                          channelKey: "basic_channel",
                          title: newNotification.title,
                          body: newNotification.description,
                        ),
                      );
                    }

                    previousNotifs = previousNotifications;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (todayNotifications.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ViewedItemsTitle(
                                  mainText:
                                      AppLocalizations.of(context)!.today),
                              const SizedBox(
                                height: CustomPageTheme.normalPadding,
                              ),
                              ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: CustomPageTheme.smallPadding,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: todayNotifications.length,
                                itemBuilder: (context, index) {
                                  Notif notification =
                                      todayNotifications[index];
                                  return buildNotificationItem(
                                      context: context,
                                      notification: notification,
                                      currentLanguage: currentLanguage,
                                      dateForm: 'hh:mm a');
                                },
                              ),
                            ],
                          ),
                        if (previousNotifications.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: CustomPageTheme.normalPadding,
                              ),
                              ViewedItemsTitle(
                                  mainText:
                                      AppLocalizations.of(context)!.previous),
                              const SizedBox(
                                height: CustomPageTheme.normalPadding,
                              ),
                              ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: CustomPageTheme.smallPadding,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: previousNotifications.length,
                                itemBuilder: (context, index) {
                                  Notif notification =
                                      previousNotifications[index];
                                  return buildNotificationItem(
                                      context: context,
                                      notification: notification,
                                      currentLanguage: currentLanguage,
                                      dateForm: 'yy-MM-dd');
                                },
                              ),
                            ],
                          ),
                      ],
                    );
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
