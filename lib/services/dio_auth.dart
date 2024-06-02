import 'package:dio/dio.dart';
import 'package:masahaty/services/api_service.dart';
import 'package:masahaty/services/dio_otp.dart';

class AuthService {
  static Future<Response> login({
    required String phoneNumber,
  }) async {
    final String otpKey = await OtpService.sendOtp(phoneNumber: phoneNumber);
    try {
      final response = await ApiService.dio.post(EndPoints.login,
       data: {
        ApiKey.phone: phoneNumber,
        ApiKey.key: otpKey,
        ApiKey.otpCode: 111111
      });
      return response;
    } catch (e) {
      return throw Exception();
    }
  }
  static Future<Response?> register({
    required String fullName,
    required String phoneNumber,
  }) async {
    Response? response;
    final String otpKey = await OtpService.sendOtp(phoneNumber: phoneNumber);
    try {
      response = await ApiService.dio.post(EndPoints.register, data: {
        ApiKey.fullName: fullName,
        ApiKey.phoneNumber: phoneNumber,
        ApiKey.key: otpKey,
        ApiKey.otpCode: 111111
      });
      return response;
    } catch (e) {
      return response;
    }
  }
}
