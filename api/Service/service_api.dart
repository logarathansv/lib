import 'package:dio/dio.dart';
import '../../models/service_model/service_model.dart';
import '../endpoints.dart';

class ServiceService {
  final Dio _dio;

  ServiceService(this._dio);

  Future<List<Service>> getServices() async {
    try {
      final response = await _dio.get(Endpoints.getServices);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((data) => Service.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load Services");
      }
    }catch (error) {
      throw Exception("Failed to load Services:$error");
    }
  }
}