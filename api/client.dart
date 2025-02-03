import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sklyit_business/api/refresh_api.dart';

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(baseUrl: 'http://192.168.77.41:3000')) {
    _init();
  }

  Future<void> _init() async {
    final storage = FlutterSecureStorage();
    await RefreshAPIService(dio).isAccessValid();
    String? token = await storage.read(key: 'token');
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}