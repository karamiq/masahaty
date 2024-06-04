import 'package:dio/dio.dart';
import 'package:masahaty/services/api_service.dart';
import '../models/notifications_model.dart';

class NotificationsService {
  Future<List<Notif>> notificationsGet({required String token}) async {
    Response response = await ApiService.dio.get(EndPoints.notifications,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
    if (response.statusCode == 200) {
      // Parse JSON response into Dart objects
      List<Notif> notifications = (response.data['data'] as List)
          .map((item) => Notif.fromJson(item))
          .toList();
      return notifications;
    } else {
      print('Request failed with status code: ${response.statusCode}');
      return [];
    }
  }
}