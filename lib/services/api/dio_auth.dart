import 'package:dio/dio.dart';
import 'package:masahaty/models/user_model.dart';
import 'package:masahaty/services/api/api_service.dart';
import 'package:masahaty/services/api/dio_otp.dart';

import '../../components/uuid_shortener.dart';

class AuthService {
  static Future<dynamic> login({
    required String phoneNumber,
  }) async {
    final users = await AuthService.usersGet();
    for (var user in users) {
      if (phoneNumber == user.phoneNumber) {
        print(user.fullName);
        try {
          final String otpKey =
              await OtpService.sendOtp(phoneNumber: phoneNumber);
          Response? response = await ApiService.dio.post(EndPoints.login,
              data: {
                ApiKey.phone: phoneNumber,
                ApiKey.key: otpKey,
                ApiKey.otpCode: 111111
              });
          final data = response.data;
          String uuid = UuidShortener.convertToShortUuid((response.data['id']));
          final user = User(
            id: data[ApiKey.id],
            shortId: uuid,
            fullName: data[ApiKey.fullName],
            phoneNumber: data[ApiKey.phoneNumber],
            role: data[ApiKey.role],
            token: data[ApiKey.token],
          );
          return user;
        } on DioException catch (e) {
          throw Exception(e.response!.statusCode);
        }
      }
    }
    return 400;
  }

  static Future<dynamic> register({
    required String fullName,
    required String phoneNumber,
  }) async {
    final users = await AuthService.usersGet();
    for (var user in users) {
      if (phoneNumber == user.phoneNumber) {
        return 400;
      }
    }
    try {
          final String otpKey =
              await OtpService.sendOtp(phoneNumber: phoneNumber);
          Response response =
              await ApiService.dio.post(EndPoints.register, data: {
            ApiKey.fullName: fullName,
            ApiKey.phoneNumber: phoneNumber,
            ApiKey.key: otpKey,
            ApiKey.otpCode: 111111
          });
          final data = response.data;
          var uuid = UuidShortener.convertToShortUuid((response.data['id']));
              final user = User(
                id: data[ApiKey.id],
                shortId: uuid,
                fullName: data[ApiKey.fullName],
                phoneNumber: data[ApiKey.phoneNumber],
                role: data[ApiKey.role],
                token: data[ApiKey.token],
              );
          return user;
        } on DioException catch (e) {
          throw Exception(e.response!.statusCode);
        }
  }
  static Future<List<User>> usersGet() async {
    try {
      Response response = await ApiService.dio.get(EndPoints.users);
      List<dynamic> data = response.data[ApiKey.data];
      List<User> users = data.map((item) => User.fromJson(item)).toList();
      return users;
    } on DioException catch (e) {
      throw Exception(e.response!.statusCode);
    }
  }
}
