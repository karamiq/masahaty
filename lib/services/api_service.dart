import 'package:dio/dio.dart';

const String api = 'http://164.92.197.198:9663';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "$api/api/",
    ),
  );
}

class EndPoints {
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String otpCode = 'otp/send-otp';
  static const String storage = 'storages';
  static const String storageId = 'storages/';
  static const String features = 'features';
  static const String govs = 'govs';
  static const String cities = 'cities';
  static const String files = 'files';
  static const String multipleFiles = 'files/multiple';
  static const String orders = 'orders';
  static const String ordersId = 'orders/';
  static const String notifications = 'notifications';
  static const String rate = '/rate';
  static const String orderAccept = ' /accept';
  static const String orderApprove = '/approve';
  static const String orderReject = ' /reject';
  static const String orderFinish = ' /finish';
}

class ApiKey {
  static const String status = 'status';
  static const String errorMessage = 'ErrorMessage';
  static const String phoneNumber = 'phoneNumber';
  static const String phone = 'phone';
  static const String fullName = 'fullName';
  static const String password = 'password';
  static const String token = 'token';
  static const String id = 'id';
  static const String role = 'role';
  static const String key = 'key';
  static const String otpCode = 'otpCode';
  static const String data = 'data';
}
