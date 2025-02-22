import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../endpoints.dart';

class LogoutAPIService{
  final Dio _dio;

  LogoutAPIService(this._dio);
  final storage = FlutterSecureStorage();

  Future<String> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await _dio.post(
          '${Endpoints.BASEURL}${Endpoints.logout}',
      );
      print(response.data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        prefs.setBool("is_logged", false);
        await storage.delete(key: 'token');
        await storage.delete(key: 'rtoken');
        await storage.delete(key: 'userId');
        return 'Logout Successful';
      } else {
        return 'Invalid Credentials !';
      }
    } catch (error) {
      throw Exception('Failed to login: $error');
    }
  }
}