class Comment {
  final String id;
  final bool deleted;
  final String creationDate;
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
      creationDate: json['creationDate'],
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



class User {
  final String id;
  final String fullName;
  final String phoneNumber;

  User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
