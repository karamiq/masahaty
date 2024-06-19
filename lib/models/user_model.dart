import '../components/uuid_shortener.dart';

class User {
  final String id;
  final String? shortId;
  final String fullName;
  final String phoneNumber;
  final dynamic role;
  final String? token;

  User({
    required this.id,
     this.shortId,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
     this.token,
  });

  // Convert a UserInfo object into a Map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      shortId: UuidShortener.convertToShortUuid(json['id']),
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      token: json['token']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortId': shortId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'token': token,
    };
  }
}
