import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masahaty/core/constants/constants.dart';
import 'package:masahaty/models/notifications_model.dart';
import 'package:masahaty/provider/change_language.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/api/dio_notifications.dart';
import 'package:masahaty/services/api/dio_order.dart';
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

  Stream<List<Notif>> getNotificationsStream() async* {
    NotificationsService notificationsService = NotificationsService();
    while (true) {
      await Future.delayed(const Duration(seconds: 1)); // Adjust delay as per requirement
      List<Notif> temp = token != null
          ? await notificationsService.notificationsGet(token: token!)
          : [];
      yield temp;
    }
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
              StreamBuilder<List<Notif>>(
                stream: getNotificationsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: NotificationsSkeleton(),);
                  } else if (snapshot.hasError) {
                    return ErrorNotifications(snapshot: snapshot,);
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const EmptyNotifications();
                  } else {
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
                      previousNotifications: previousNotifications,
                    );
                  }
                },
              ),
              const SizedBox(height: CustomPageTheme.normalPadding,)
            ],
          ),
        ),
      ),
    );
  }
}