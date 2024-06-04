import 'owner&renter.dart';
import 'storage&features_model.dart';

class Order {
  String id;
  bool deleted;
  DateTime creationDate;
  Storage storage;
  DateTime startDate;
  Owner owner;
  Renter renter;
  int orderStatus;
  DateTime endDate;
  String name;
  int count;
  List<String> images;

  Order({
    required this.id,
    required this.deleted,
    required this.creationDate,
    required this.storage,
    required this.startDate,
    required this.owner,
    required this.renter,
    required this.orderStatus,
    required this.endDate,
    required this.name,
    required this.count,
    required this.images,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      deleted: json['deleted'],
      creationDate: DateTime.parse(json['creationDate']),
      storage: Storage.fromJson(json['storage']),
      startDate: DateTime.parse(json['startDate']),
      owner: Owner.fromJson(json['owner']),
      renter: Renter.fromJson(json['renter']),
      orderStatus: json['orderStatus'],
      endDate: DateTime.parse(json['endDate']),
      name: json['name'],
      count: json['count'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'storage': storage.toJson(),
      'startDate': startDate.toIso8601String(),
      'owner': owner.toJson(),
      'renter': renter.toJson(),
      'orderStatus': orderStatus,
      'endDate': endDate.toIso8601String(),
      'name': name,
      'count': count,
      'images': images,
    };
  }
}
