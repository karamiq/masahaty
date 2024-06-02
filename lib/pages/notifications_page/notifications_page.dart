import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/components/viewed_item_title.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/models/notifications_model.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_notifications.dart';
import 'package:masahaty/services/dio_order.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  get token => ref.read(currentUserProvider)?.token;
  OrderService orderService = OrderService();
  Future<List<Notif>> getNotifications() async {
    NotificationsService notificationsService = NotificationsService();
    List<Notif>? temp =
        await notificationsService.notificationsGet(token: token);
    return temp;
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
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
              const SizedBox(
                height: CustomPageTheme.bigPadding,
              ),
              FutureBuilder<List<Notif>>(
                future: getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
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
                                      context, notification);
                                },
                              ),
                            ],
                          ),
                        if (previousNotifications.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                      context, notification);
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotificationItem(BuildContext context, Notif notification) {
    bool isActionTaken = notification.deleted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(CoustomBorderTheme.normalBorderRaduis)),
          child: ListTile(
            title: Text(notification.title),
            subtitle: Text(
              isActionTaken
                  ? (notification.deleted ? 'Approved' : 'Rejected')
                  : notification.description,
            ),
            leading: const CircleAvatar(),
          ),
        ),
        if (!isActionTaken) // Show buttons only if action has not been taken
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CoustomBorderTheme.normalBorderRaduis)),
                    backgroundColor: CustomColorsTheme.availableRadioColor,
                  ),
                  onPressed: () {
                    setState(() {
                      orderService.orderReject(
                          token: token, id: notification.notifyFor);
                      notification.deleted = true;
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.accept),
                ),
              ),
              const SizedBox(width: CustomPageTheme.smallPadding),
              Expanded(
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CoustomBorderTheme.normalBorderRaduis)),
                    backgroundColor: CustomColorsTheme.unAvailableRadioColor,
                  ),
                  onPressed: () {
                    setState(() {
                      orderService.orderReject(
                          token: token, id: notification.notifyFor);
                      notification.deleted = false;
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.reject),
                ),
              ),
            ],
          )
      ],
    );
  }
}
