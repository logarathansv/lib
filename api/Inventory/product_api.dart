import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:sklyit_business/api/endpoints.dart';

import '../../models/product_model/product_model.dart';


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

  Future<void> addBusinessProduct(Map<String, dynamic> productData) async {
    try{
      final response = await _dio.post(
          Endpoints.addBusinessProduct,
          data: productData
      );
      print(response.data);
      if (response.statusCode == 201) {
        print('Product added successfully!');
      } else {
        print('Failed to add product: ${response.statusCode}');
      }
    }
    catch (error){
      throw Exception("Failed to add Product:$error");
    }
  }

  Future<void> addProduct(ProductInventory product, File? image) async {
    try {
      // Create a FormData object and add all fields
      FormData formData = FormData.fromMap({
        'name': product.name,
        'units': product.units,
        'category': product.category,
        'sub_category': product.subCategory,
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

  Future<void> addProducts(List<Map<String, dynamic>> data) async {
    try{
      print(data);
      final response = await _dio.post(
          Endpoints.addBusinessProducts,
          data: data
      );
      print(response.data);
      if(response.statusCode == 201){
        print('Products added successfully!');
      } else {
        print('Failed to add products: ${response.statusCode}');
      }
    }
    catch (error){
      throw Exception("Failed to add Products:$error");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await _dio.delete(
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

  Future<void> updateProduct(Map<String, dynamic> formData, String id) async {
    try {
      print(formData);
      print(id);
      final response = await _dio.put(
        '${Endpoints.editBusinessProduct}/$id',
        data: formData,
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

  Future<List<ProductInventory>> getAllProducts() async {
    try {
      print('getting inventory products');
      final response = await _dio.get(
          Endpoints.getInventory
      );
      print('response data: ${response.data}');
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((data) => ProductInventory.fromJson(data)).toList();
      }
      else {
        throw Exception("Failed to load inventory Products");
      }
    } catch (error) {
      throw Exception("Failed to load inventory Products:$error");
    }
  }
}
