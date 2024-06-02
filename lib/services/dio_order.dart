import 'package:dio/dio.dart';
import 'package:masahaty/models/order_model.dart';
import 'package:masahaty/models/warehouse_model.dart';
import 'package:masahaty/services/api_service.dart';

class OrderService {
  Future<void> orderPost({
    required String token,
    required String storageId,
    required String startDate,
    required String endDate,
    required String name,
    required int count,
    required List<String> images,
  }) async {
    Response response = await ApiService.dio.post(EndPoints.orders,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "storageId": storageId,
          "startDate": startDate,
          "endDate": endDate,
          "name": name,
          "count": count,
          "images": images
        });
    print(response.data);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusCode);
    }
  }

  List<Order> orders = [];
  Future<List<Order>> orderGet() async {
    Response response = await ApiService.dio.get(EndPoints.orders);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data[ApiKey.data];
      orders = data.map((item) => Order.fromJson(item)).toList();
      return orders;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Warehouse> orderGetById({required String id}) async {
    Response response = await ApiService.dio.get(EndPoints.ordersId + id);
    if (response.statusCode == 200) {
      Warehouse data = Warehouse.fromJson(response.data);
      return data;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<void> orderApprove({required String token, required String id}) async {
    Response response = await ApiService.dio.put(
      EndPoints.ordersId + id + EndPoints.orderApprove,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }
  }

  Future<void> orderAccept({required String token, required String id}) async {
    Response response = await ApiService.dio.put(
      EndPoints.ordersId + id + EndPoints.orderAccept,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }
  }

  Future<void> orderReject({required String token, required String id}) async {
    Response response = await ApiService.dio.put(
      EndPoints.ordersId + id + EndPoints.orderReject,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }
  }

  Future<void> orderFinish({required String token, required String id}) async {
    Response response = await ApiService.dio.put(
      EndPoints.ordersId + id + EndPoints.orderFinish,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode);
    }
  }
}
