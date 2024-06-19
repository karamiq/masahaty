import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';

class NotificationController {
  static ReceivedAction? initialAction;

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) => onActionReceivedImplementationMethod(silentData));
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {
      if (receivePort == null) {
        print(
            'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
            IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          print('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {}

  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    const url = "http://google.com";
    final dio = Dio();
    final re = await dio.get(url);
    print(re.data);
    print("long task done");
  }

  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'alerts',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> scheduleNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await myNotifyScheduleInHours(
        title: 'test',
        msg: 'test message',
        heroThumbUrl:
            'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
        hoursFromNow: 5,
        username: 'test user',
        repeatNotif: false);
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}

Future<void> myNotifyScheduleInHours({
  required int hoursFromNow,
  required String heroThumbUrl,
  required String username,
  required String title,
  required String msg,
  bool repeatNotif = false,
}) async {
  var nowDate = DateTime.now().add(Duration(hours: hoursFromNow, seconds: 5));
  await AwesomeNotifications().createNotification(
    schedule: NotificationCalendar(
      hour: nowDate.hour,
      minute: 0,
      second: nowDate.second,
      repeats: repeatNotif,
    ),
    content: NotificationContent(
      id: -1,
      channelKey: 'basic_channel',
      title: '${Emojis.food_bowl_with_spoon} $title',
      body: '$username, $msg',
      bigPicture: heroThumbUrl,
      notificationLayout: NotificationLayout.BigPicture,
      color: Colors.black,
      backgroundColor: Colors.black,
      payload: {'actPag': 'myAct', 'actType': 'food', 'username': username},
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'NOW',
        label: 'btnAct1',
      ),
      NotificationActionButton(
        key: 'LATER',
        label: 'btnAct2',
      ),
    ],
  );
}
