import 'package:dio/dio.dart';
import 'package:masahaty/models/notifications_model.dart';
import 'package:masahaty/services/api/api_service.dart';

class NotificationsService {
  Future<List<Notif>> notificationsGet({required String token}) async {
      Response response = await ApiService.dio.get(
        EndPoints.notifications,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        List<Notif> notifications = (response.data['data'] as List)
            .map((item) => Notif.fromJson(item))
            .toList();
        
        // Iterate through new notifications and send a notification for each
        return notifications;
      } else {
        return [];
      }
  }

}
