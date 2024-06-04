import 'package:dio/dio.dart';
import 'package:masahaty/models/comments_model.dart';
import 'package:masahaty/services/api_service.dart';

class CommentsService {
  Future<List<Comment>> commentsGetById(
      {required String token, required String id}) async {
    Response response = await ApiService.dio.get(EndPoints.comments + id,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
    if (response.statusCode == 200) {
      List<dynamic> data = response.data[ApiKey.data];
      List<Comment> comments =
          data.map((json) => Comment.fromJson(json)).toList();
      return comments;
    } else {
      return [];
    }
  }

  Future<void> commentsPost(
      {required String token,
      required String commentId,
      required String content}) async {
    Response response =
        await ApiService.dio.post(EndPoints.comments + commentId,
            options: Options(headers: {
              'Authorization': 'Bearer $token',
            }));
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print('error: ${response.statusCode}');
    }
  }
}
