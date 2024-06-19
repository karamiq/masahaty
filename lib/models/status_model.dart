class Status {
  final int? statusCode;
  final String? message;

  Status({required this.statusCode, required this.message});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(statusCode: json['statusCode'], message: json['message']);
  }
}
