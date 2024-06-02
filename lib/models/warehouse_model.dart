class Warehouse {
  final String name;
  final String description;
  final double price;
  final int numberOfRooms;
  final double space;
  final List<Map<String, dynamic>> storageFeatures;
  final double latitude;
  final double longitude;
  final String address;
  final Map<String, dynamic> owner;
  final List<String> images;
  final Map<String, dynamic> city;
  final bool isBookmarked;
  final double distance;
  final double rating;
  final String id;
  final bool deleted;
  final String creationDate;

  Warehouse({
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
    required this.id,
    required this.deleted,
    required this.creationDate,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      numberOfRooms: json['numberOfRooms'],
      space: json['space'],
      storageFeatures: List<Map<String, dynamic>>.from(json['storageFeatures']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      owner: json['owner'],
      images: List<String>.from(json['images']),
      city: json['city'],
      isBookmarked: json['isBookmarked'],
      distance: json['distance'],
      rating: json['rating']?.toDouble() ?? 0.0,
      id: json['id'],
      deleted: json['deleted'],
      creationDate: json['creationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'numberOfRooms': numberOfRooms,
      'space': space,
      'storageFeatures': storageFeatures,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'owner': owner,
      'images': images,
      'city': city,
      'isBookmarked': isBookmarked,
      'distance': distance,
      'rating': rating,
      'id': id,
      'deleted': deleted,
      'creationDate': creationDate,
    };
  }
}
