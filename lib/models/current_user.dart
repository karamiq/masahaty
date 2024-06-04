import 'dart:convert';

class UserInfo {
  final String id;
  final String shortId;
  final String fullName;
  final String phoneNumber;
  final dynamic role;
  final String token;

  UserInfo({
    required this.id,
    required this.shortId,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    required this.token,
  });

  // Convert a UserInfo object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shortId': shortId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'token': token,
    };
  }

  // Convert a Map into a UserInfo object.
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'],
      shortId: map['shortId'],
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) => UserInfo.fromMap(json.decode(source));
}
