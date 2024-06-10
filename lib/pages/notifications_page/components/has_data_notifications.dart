
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../components/viewed_item_title.dart';
import '../../../core/constants/constants.dart';
import '../../../models/notifications_model.dart';
import '../notifications_page.dart';

class HasDataNotifications extends StatelessWidget {
  const HasDataNotifications({
    super.key,
    required this.todayNotifications,
    required this.currentLanguage,
    required this.previousNotifications,
  });

  final List<Notif> todayNotifications;
  final dynamic currentLanguage;
  final List<Notif> previousNotifications;

  @override
  Widget build(BuildContext context) {
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
  }
}
