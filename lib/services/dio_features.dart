import 'package:dio/dio.dart';
import 'package:masahaty/services/api_service.dart';

class FeaturesService {
  Future<String> featuresGet(String featureName) async {
    Response response = await ApiService.dio.get(EndPoints.features);
    if (response.statusCode == 200) {
      List<dynamic> dataList = response.data['data'];
      dynamic feature = dataList.firstWhere(
          (feature) => feature['name'] == featureName,
          orElse: () => throw Exception());
      return feature['id'];
    }
    return throw Exception();
  }
}
