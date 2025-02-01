// lib/api/product_service.dart
import 'package:dio/dio.dart';

class ProductService {
  final Dio dio;

  ProductService(this.dio);

  Future<List<dynamic>> getProducts() async {
    final response = await dio.get('/bs/product');
    return response.data;
  }

  Future<Map<String, dynamic>> createProduct({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'Pname': name,
      'Pdesc': description,
      'Pprice': price.toString(),
      'Pqty': quantity.toString(),
      'image': await MultipartFile.fromFile(imagePath),
    });

    final response = await dio.post(
      '/bs/products',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data;
  }
}
