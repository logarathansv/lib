import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/api/endpoints.dart';
import '../../models/product_model/product_model.dart';
import 'package:path/path.dart';
import '../../providers/business_main.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

final productApiProvider=FutureProvider((ref)=>ProductService(ref.watch(apiClientProvider).dio));

class ProductService {
  ProductService(this._dio);

  final Dio _dio;

  Future<List<Product>> getProducts() async {
    try {
      print('getting products');
      final response = await _dio.get(
          Endpoints.getProducts
      );
      print('response data: ${response.data}');
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        // print(response.data);
        return jsonData.map((data) => Product.fromJson(data)).toList();
      }
      else {
        throw Exception("Failed to load Products");
      }
    } catch (error) {
      throw Exception("Failed to load Products:$error");
    }
  }

  Future<void> addProduct(Product product, File? image) async {
    try {
      // Create a FormData object and add all fields
      FormData formData = FormData.fromMap({
        'name': product.name,
        'price': product.price,
        'quantity': product.quantity,
        if (product.description != null) 'description': product.description,
      });

      // If an image file is provided, add it as a MultipartFile
      if (image != null) {
        String? mimeType = lookupMimeType(image.path); // Get MIME type
        List<String>? mimeTypeParts = mimeType?.split('/');

        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: basename(image.path),
              contentType: mimeTypeParts != null
                  ? MediaType(mimeTypeParts[0], mimeTypeParts[1])
                  : null, // Add content type
            ),
          ),
        );
      }
       print(formData.fields);
      print(formData.files);
      final response = await _dio.post(
        Endpoints.editInventory,
        data: formData,
      );
      if (response.statusCode == 201) {
        print('Product created successfully!');
      } else {
        print('Failed to create product: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception("Failed to add Product:$error");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await _dio.put(
      '${Endpoints.deleteProduct}/$productId',
    );
      if (response.statusCode == 200) {
        print('Product deleted successfully!');
      } else {
        print('Failed to delete product: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception("Failed to delete Product:$error");
    }
  }

  Future<void> updateProduct(Product product, File? imageFile) async {
    try {
      // Create a map for product fields
      Map<String, dynamic> updateFields = {
        'name': product.name,
        'description': product.description,
        'price': product.price.toString(), // Ensure numbers are converted to strings
        'quantity': product.quantity.toString(),
      };

      FormData formData = FormData.fromMap(updateFields);

      // If an image file is provided, add it to the form data
      if (imageFile != null) {
        String? mimeType = lookupMimeType(imageFile.path); // Get MIME type
        List<String>? mimeTypeParts = mimeType?.split('/'); // Split type/subtype

        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: basename(imageFile.path),
              contentType: mimeTypeParts != null
                  ? MediaType(mimeTypeParts[0], mimeTypeParts[1])
                  : null,
            ),
          ),
        );
      }

      final response = await _dio.put(
        '${Endpoints.editInventory}/${product.id}',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        print('Product updated successfully!');
      } else {
        print('Failed to update product: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception("Failed to update Product: $error");
    }
  }

}
