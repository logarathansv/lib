
import 'package:dio/dio.dart';
import 'package:sklyit_business/models/customer_model/customer_class.dart';

import '../endpoints.dart';

class CustomerService {
  CustomerService(this._dio);
  final Dio _dio;

  Future<List<Customer>> getCustomers() async{
    try{
      final response = await _dio.get(
          Endpoints.getCustomers
      );
      if(response.statusCode == 200){
        List<dynamic> jsonData = response.data;
        return jsonData.map((data) => Customer.fromJson(data)).toList();
      }else{
        throw Exception("Failed to load Customers");
      }
    }catch(error){
      throw Exception("Failed to load Customers:$error");
    }
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      final response = await _dio.post(
          Endpoints.editCustomer,
          data: customer.toJson()
      );
      if (response.statusCode == 201) {
        print('Customer created successfully!');
      } else {
        throw Exception("Failed to create Customer");
      }
    } catch (error) {
      throw Exception("Failed to create Customer:$error");
    }
  }
  Future<void> deleteCustomer(String customerId) async{
    try{
      final response = await _dio.put(
          '${Endpoints.deleteCustomer}/$customerId'
      );
      if(response.statusCode == 200){
        print('Customer deleted successfully!');
      }else{
        throw Exception("Failed to delete Customer");
      }
    }catch(error){
      throw Exception("Failed to delete Customer:$error");
    }
  }

  Future<void> editCustomer(Customer customer) async{
    try{
      final response = await _dio.put(
          '${Endpoints.editCustomer}/${customer.custId}',
          data: customer.toJson()
      );
      if(response.statusCode == 200){
        print('Customer edited successfully!');
      }else{
        throw Exception("Failed to edit Customer");
      }
    }catch(error){
      throw Exception("Failed to edit Customer:$error");
    }
  }
}

