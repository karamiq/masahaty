
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/constants.dart';
import '../../../models/notifications_model.dart';

class NotificationItem extends StatelessWidget {
  final BuildContext context;
  final Notif notification;
  final dynamic currentLanguage;
  final String dateForm;

  const NotificationItem({
    Key? key,
    required this.context,
    required this.notification,
    required this.currentLanguage,
    required this.dateForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: CoustomBorderTheme.borderWidth,
              color: CustomColorsTheme.dividerColor,
            ),
            borderRadius: BorderRadius.circular(
              CoustomBorderTheme.normalBorderRaduis,
            ),
          ),
          child: ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.description),
            leading: const CircleAvatar(),
            trailing: Column(
              children: [
                Text(
                  DateFormat(dateForm, currentLanguage.languageCode)
                      .format(notification.creationDate),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}