import 'package:dio/dio.dart';
import 'package:sklyit_business/api/endpoints.dart';
import 'package:sklyit_business/models/crm_model/customer_analytics/customer_analytics_model.dart';

class CustomerInsightsApi {
  CustomerInsightsApi(this._dio);
  final Dio _dio;

  Future<List<CustomerPercentage>> getCustomerInsights() async {
    try{
      final response = await _dio.get(Endpoints.newoldCustomersRevenue);
      print(response.data);
      List<CustomerPercentage> customerRevenue = [];
      if(response.statusCode == 200){
        customerRevenue = (response.data as List).map((e) => CustomerPercentage.fromJson(e)).toList();
      }
      return customerRevenue;
    }
    catch(e){
      print(e);
      return [];
    }
  }

  Future<List<CustomerRevenue>> getTopCustomersByRevenue() async {
    try{
      final response = await _dio.get(Endpoints.topCustomersRevenue);
      print(response.data);
      List<CustomerRevenue> customerRevenue = [];
      if(response.statusCode == 200){
        customerRevenue = (response.data as List).map((e) => CustomerRevenue.fromJson(e)).toList();
      }
      return customerRevenue;
    }
    catch(e){
      print(e);
      return [];
    }
  }

  Future<List<CustomerRevenue>> getBottomCustomersByRevenue() async {
    try{
      final response = await _dio.get(Endpoints.bottomCustomersRevenue);
      print(response.data);
      List<CustomerRevenue> customerRevenue = [];
      if(response.statusCode == 200){
        customerRevenue = (response.data as List).map((e) => CustomerRevenue.fromJson(e)).toList();
      }
      return customerRevenue;
    }
    catch(e){
      print(e);
      return [];
    }
  }
}