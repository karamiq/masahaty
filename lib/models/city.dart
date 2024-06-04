
class City {
  String id;
  bool deleted;
  DateTime creationDate;
  String name;
  String govId;
  String govName;

  City({
    required this.id,
    required this.deleted,
    required this.creationDate,
    required this.name,
    required this.govId,
    required this.govName,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      deleted: json['deleted'],
      creationDate: DateTime.parse(json['creationDate']),
      name: json['name'],
      govId: json['govId'],
      govName: json['govName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'name': name,
      'govId': govId,
      'govName': govName,
    };
  }
}
