
import 'package:masahaty/services/api/api_service.dart';

class OtpService {
  static Future<String> sendOtp({required String phoneNumber}) async {
    try {
      final response = await ApiService.dio.post(
        EndPoints.otpCode,
        data: {"phone": phoneNumber},
      );
      final otpKey = response.data['key']; // Assuming the key is returned in the response
      return otpKey;
    } catch (e) {
      print('Error sending OTP: $e');
      throw e; // Rethrow the error to be caught by the caller
    }
  }
}


