import 'package:dio/dio.dart';

import 'api_service.dart';

class BookmarkService {
  Future<void> bookmarkGet({required String token}) async {
    Response response = await ApiService.dio.get(
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        EndPoints.storage);
    if (response.statusCode == 200) {
      print('seccessful posting');
      print(response.data);
    } else {
      print('failed');
      throw Exception();
    }
  }
}