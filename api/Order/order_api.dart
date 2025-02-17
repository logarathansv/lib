import 'package:dio/dio.dart';
import 'package:sklyit_business/models/order_model/order_model.dart';
import '../endpoints.dart';

class OrderService{
  final Dio _dio;
  OrderService(this._dio);

  Future<List<Order>> getOrders() async{
    try{
      final response = await _dio.get(
          Endpoints.getOrders
      );
      if(response.statusCode == 200){
        List<dynamic> jsonData = response.data;
        return jsonData.map((data) => Order.fromJson(data)).toList();
      }
      else{
        throw Exception("Failed to load Orders");
      }
    }
    catch(error){
      throw Exception("Failed to load Orders:$error");
    }
  }

  Future<void> addOrder(CreateOrder order) async{

    try{
      final response = await _dio.post(
          Endpoints.editOrder,
          data:order.toJson()
      );
      if(response.statusCode == 201){
        print('Order created successfully!');
      }
      else{
        throw Exception("Failed to create Order");
      }
    }
    catch(error){
      throw Exception("Failed to create Order:$error");
    }
  }
}