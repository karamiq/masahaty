import 'package:dio/dio.dart';
import 'package:masahaty/services/api_service.dart';
import '/models/warehouse_model.dart';

class StorageService {
  late List<Warehouse> storages = [];
  
  Future<List<Warehouse>> storageGet() async {
    try {
      Response response = await ApiService.dio.get(EndPoints.storage);
      List<dynamic> data = response.data[ApiKey.data];
      storages = data.map((item) => Warehouse.fromJson(item)).toList();
      return storages;
    } catch (e) {
      return [];
    }
  }
  Future<Warehouse> storageGetById({required String id}) async {
    try {
      Response response = await ApiService.dio.get(EndPoints.storageId + id);
      if (response.statusCode == 200) {
        Warehouse data = Warehouse.fromJson(response.data);
        return data;
      } else {
        throw Exception(response.statusCode);
      }
    } on DioException catch (dioError) {
      throw Exception(dioError.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> storagePost({
    required String token,
    required String name,
    required String description,
    required double price,
    required int numberOfRooms,
    required double space,
    required double latitude,
    required double longitude,
    required String govId,
    required String cityId,
    required String address,
    required List<String> featuresIds,
    required List<String> images,
  }) async {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "price": price,
      "numberOfRooms": numberOfRooms,
      "space": space,
      "latitude": latitude,
      "longitude": longitude,
      "govId": govId,
      "cityId": cityId,
      "address": address,
      "featureIds": featuresIds,
      "images": images, // example image URL
    };
    Response response = await ApiService.dio.post(
        data: data,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        EndPoints.storage);
    if (response.statusCode != 200) {
      throw Exception();
    }
  }

  Future<void> storageRate(
      {required String token, required String id, required double rate}) async {
    try {
      Response response =
          await ApiService.dio.post(EndPoints.storageId + id + EndPoints.rate,
              data: {
                "rating": rate,
              },
              options: Options(headers: {'Authorization': 'Bearer $token'}));
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> storageDelete(
      {required String token, required String id}) async {
    try {
      Response response = await ApiService.dio.delete(
        EndPoints.storageId + id,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete storage with status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
