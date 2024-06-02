import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationStatues extends StateNotifier<bool?> {
  NotificationStatues() : super(null);


  static const String notifsKey = 'notifs_status';
  Future<void> changeNotifsStatues(bool newStatues) async {
    state = newStatues;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notifsKey, newStatues);
   
  }

  Future<void> loadNotifsStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final currentStatus = prefs.getBool(notifsKey) ?? true;
    if (currentStatus != null) {
      state = currentStatus;
    }
  }
}

final notifsStatusProvider = StateNotifierProvider<NotificationStatues, bool?>(
    (ref) => NotificationStatues());
