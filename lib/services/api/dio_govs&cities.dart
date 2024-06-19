import 'package:dio/dio.dart';

import 'api_service.dart';

class Govs {
  Future<String> govGet(String govName) async {
    Response response = await ApiService.dio.get(EndPoints.govs);
    if (response.statusCode == 200) {
      List<dynamic> dataList = response.data['data'];
      dynamic govs = dataList.firstWhere((gov) => gov['name'] == govName,
          orElse: () => throw Exception());
      return govs['id'];
    }
    return throw Exception();
  }
}

class Cities {
  Future<Map<String, dynamic>> cityGet(String? cityName) async {
    Response response = await ApiService.dio.get(EndPoints.cities);
    if (response.statusCode == 200) {
      List<dynamic> dataList = response.data['data'];
      dynamic cities = dataList.firstWhere((city) => city['name'] == cityName,
          orElse: () => throw Exception());
      print(cities);
      return cities;
    }
    return throw Exception();
  }
}