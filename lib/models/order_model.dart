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

class Storage {
  String id;
  bool deleted;
  DateTime creationDate;
  String name;
  String description;
  double price;
  int numberOfRooms;
  double space;
  List<StorageFeature> storageFeatures;
  double latitude;
  double longitude;
  String address;
  Owner owner;
  List<String> images;
  City? city;
  bool isBookmarked;
  double distance;
  double rating;

  Storage({
    required this.id,
    required this.deleted,
    required this.creationDate,
    required this.name,
    required this.description,
    required this.price,
    required this.numberOfRooms,
    required this.space,
    required this.storageFeatures,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.owner,
    required this.images,
    required this.city,
    required this.isBookmarked,
    required this.distance,
    required this.rating,
  });

  factory Storage.fromJson(Map<String, dynamic> json) {
    return Storage(
      id: json['id'],
      deleted: json['deleted'],
      creationDate: DateTime.parse(json['creationDate']),
      name: json['name'],
      description: json['description'],
      price: json['price'],
      numberOfRooms: json['numberOfRooms'],
      space: json['space'],
      storageFeatures: (json['storageFeatures'] as List)
          .map((i) => StorageFeature.fromJson(i))
          .toList(),
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      owner: Owner.fromJson(json['owner']),
      images: List<String>.from(json['images']),
      city: json['city'] != null ? City.fromJson(json['city']) : null,

      isBookmarked: json['isBookmarked'],
      distance: json['distance'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'name': name,
      'description': description,
      'price': price,
      'numberOfRooms': numberOfRooms,
      'space': space,
      'storageFeatures': storageFeatures.map((i) => i.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'owner': owner.toJson(),
      'images': images,
      'city': city?.toJson(),
      'isBookmarked': isBookmarked,
      'distance': distance,
      'rating': rating,
    };
  }
}

class StorageFeature {
  String id;
  String name;

  StorageFeature({
    required this.id,
    required this.name,
  });

  factory StorageFeature.fromJson(Map<String, dynamic> json) {
    return StorageFeature(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Owner {
  String id;
  String fullName;
  String phoneNumber;

  Owner({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}

class Renter {
  String id;
  String fullName;
  String phoneNumber;

  Renter({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
  });

  factory Renter.fromJson(Map<String, dynamic> json) {
    return Renter(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}

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
