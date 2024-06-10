import 'package:dio/dio.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:crypto/crypto.dart';
import 'package:masahaty/models/notifications_model.dart';
import 'dart:convert'; // for utf8.encode
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masahaty/services/api_service.dart'; // Ensure correct import

class NotificationsService {

  // Function to generate a unique integer ID from a UUID
  int _generateIdFromUuid(String uuid) {
    var bytes = utf8.encode(uuid); // Convert UUID to a list of bytes
    var digest = sha256.convert(bytes); // Hash the UUID using SHA-256
    return digest.bytes.reduce((value, element) => value + element); // Convert hash bytes to a single integer
  }

  Future<void> _storeNotifiedIds(Set<String> notifiedIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notifiedIds', notifiedIds.toList());
  }

  Future<Set<String>> _getNotifiedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('notifiedIds')?.toSet() ?? {};
  }

  Future<List<Notif>> notificationsGet({required String token}) async {
    Response response = await ApiService.dio.get(EndPoints.notifications,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
    if (response.statusCode == 200) {
      List<Notif> notifications = (response.data['data'] as List)
          .map((item) => Notif.fromJson(item))
          .toList();

      // Get the set of notified IDs from shared preferences
      Set<String> notifiedIds = await _getNotifiedIds();

      // Compare with previous notifications to find new ones
      for (Notif notif in notifications) {
        if (!notifiedIds.contains(notif.id)) {
          // Generate unique integer ID from UUID
          int notifId = _generateIdFromUuid(notif.id);

          // Send notification for the new item
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: notifId, // Ensure the ID is an integer
              channelKey: 'basic_channel',
              title: notif.title,
              body: notif.description,
            ),
          );
          // Add the ID to the notified IDs set
          notifiedIds.add(notif.id);
        }
      }

      // Store the updated set of notified IDs
      await _storeNotifiedIds(notifiedIds);

      // Update the previous notifications list

      return notifications;
    } else {
      print('Request failed with status code: ${response.statusCode}');
      return [];
    }
  }
}
