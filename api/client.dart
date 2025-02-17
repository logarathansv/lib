import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sklyit_business/api/refresh_api.dart';

import 'endpoints.dart';

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(baseUrl: Endpoints.BASEURL)) {
    _init();
  }

  Future<void> _init() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');

    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    await RefreshAPIService(dio).isAccessValid();
  }

}