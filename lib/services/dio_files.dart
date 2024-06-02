import 'dart:io';
import 'package:dio/dio.dart';
import 'package:masahaty/services/api_service.dart';

class FileService {
  
  Future<List<String>> multipleFiles(
      {required List<File> images, required String token}) async {
    FormData formData = FormData();
    for (var imageFile in images) {
      String fileName = imageFile.path.split('/').last;
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      ));
    }
    Response response = await ApiService.dio.post(EndPoints.multipleFiles,
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
    if (response.statusCode == 200) {
      List<String> urls = extractUrls(response.data);
      print('urls: $urls');
      return urls;
    } else {
      throw Exception(
          "Failed to upload files. Status code: ${response.statusCode}");
    }
  }
}



List<String> extractUrls(dynamic responseData) {
  List<dynamic> jsonData = responseData;
  List<String> urls = [];

  for (var data in jsonData) {
    if (data.containsKey('url')) {
      urls.add("http://164.92.197.198:9663${data['url']}");
    }
  }
  return urls;
}
