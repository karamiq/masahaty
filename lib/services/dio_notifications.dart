import 'package:dio/dio.dart';
import 'package:masahaty/services/api_service.dart';
import '../models/notifications_model.dart';

class NotificationsService {
  Future<List<Notif>> notificationsGet({required String token}) async {
    Response response = await ApiService.dio.get(EndPoints.notifications,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
    // Check if request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse JSON response into Dart objects
      List<Notif> notifications = (response.data['data'] as List)
          .map((item) => Notif.fromJson(item))
          .toList();
      //final orderService = OrderService();
      //for (Notif notification in notifications) {
      //  notification.warehouseNotify =
      //      await orderService.orderGetById(id: notification.notifyFor);
      //}
      return notifications;
    } else {
      // Handle error if request was not successful
      print('Request failed with status code: ${response.statusCode}');
      return [];
    }
  }
}