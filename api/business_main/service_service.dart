// lib/api/service_service.dart
import 'package:dio/dio.dart';

class ServiceService {
  final Dio dio;

  ServiceService(this.dio);

  Future<List<dynamic>> getServices() async {
    final response = await dio.get('/bs/service');
    return response.data['services'];
  }

  Future<Map<String, dynamic>> createService({
    required String name,
    required String description,
    required double cost,
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'ServiceName': name,
      'ServiceDesc': description,
      'ServiceCost': cost.toString(),
      'image': await MultipartFile.fromFile(imagePath),
    });

    final response = await dio.post(
      '/bs/services',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data;
  }

  Future<void> deleteService(int serviceId) async {
    await dio.put('/bs/service/$serviceId');
  }
}
