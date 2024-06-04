import 'user.dart';

class Comment {
  final String id;
  final bool deleted;
  final DateTime creationDate;
  final String content;
  final User user;
  final List<Reply> replies;

  Comment({
    required this.id,
    required this.deleted,
    required this.creationDate,
    required this.content,
    required this.user,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      deleted: json['deleted'],
       creationDate: DateTime.parse(json['creationDate']),
      content: json['content'],
      user: User.fromJson(json['user']),
      replies: (json['replies'] as List<dynamic>)
          .map((replyJson) => Reply.fromJson(replyJson))
          .toList(),
    );
  }
}

class Reply {
  final String commentId;
  final String content;
  final User user;
  final String creationDate;

  Reply({
    required this.commentId,
    required this.content,
    required this.user,
    required this.creationDate,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      commentId: json['commentId'],
      content: json['content'],
      user: User.fromJson(json['user']),
      creationDate: json['creationDate'],
    );
  }
}