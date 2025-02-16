import 'package:dio/dio.dart';
import 'package:sklyit_business/api/endpoints.dart';
import '../../models/product.dart';

class ProductService{
  final Dio _dio=Dio();


  Future<List<Product>> getProducts() async{
    try {
      final response = await _dio.get(
          '${Endpoints.baseUrl}${Endpoints.getProducts}'
      );
      if(response.statusCode==200){
        List<dynamic> jsonData=response.data;
        return jsonData.map((data)=>Product.fromJson(data)).toList();
      }
      return response.data;
    }catch(error){
      throw Exception("Failed to load Products:$error");
    }

  }

}