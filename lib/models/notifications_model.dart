class Notif {
  String id;
  bool deleted;
  DateTime creationDate;
  String title;
  String description;
  String? picture;
  String notifyFor;
  String userId;
  Notif({
    required this.id,
    required this.deleted,
    required this.creationDate,
    required this.title,
    required this.description,
    required this.picture,
    required this.notifyFor,
    required this.userId,
  });
  factory Notif.fromJson(Map<String, dynamic> json) {
    return Notif(
      id: json['id'],
      deleted: json['deleted'],
      creationDate: DateTime.parse(json['creationDate']),
      title: json['title'],
      description: json['description'],
      picture: json['picture'],
      notifyFor: json['notifyFor'],
      userId: json['userId'],
    );
  }
}
