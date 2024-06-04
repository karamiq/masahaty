import 'package:dio/dio.dart';
import 'package:masahaty/models/comments&replies_model.dart';
import 'package:masahaty/services/api_service.dart';

class CommentsService {
  // Get comments by ID
  Future<List<Comment>> commentsGetById({
    required String token,
    required String id,
  }) async {
    try {
      final response = await ApiService.dio.get(
        EndPoints.comments + id,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data[ApiKey.data];
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        // Handle non-200 status codes
        return [];
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching comments: $e');
      return [];
    }
  }

  // Post a comment
  Future<void> commentsPost({
    required String token,
    required String id,
    required String content,
    String? parentCommentId,
  }) async {
    try {
      await ApiService.dio.post(
        EndPoints.comments + id,
        data: {'content': content, 'parentCommentId': parentCommentId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      print('Error posting comment: $e');
    }
  }

  // Delete a comment
  Future<void> commentsDelete({
    required String token,
    required String id,
    required String? commentId,
  }) async {
    try {
      await ApiService.dio.delete(
        EndPoints.comments + id,
        data: {'commentId': commentId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }
}
