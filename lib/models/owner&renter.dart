
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