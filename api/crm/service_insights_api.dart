import 'package:dio/dio.dart';
import 'package:sklyit_business/api/endpoints.dart';
import 'package:sklyit_business/models/crm_model/service_insights/service_crm_models.dart';

class ServiceInsightsAPI {
  ServiceInsightsAPI(this._dio);
  final Dio _dio;

  Future<List<ServiceData>> getTopServicesByBookings() async {
    try {
      final response = await _dio.get(Endpoints.topServicesCount);
      print(response.data);

      if (response.statusCode == 200) {
        List<ServiceData> services = (response.data as List)
            .map((json) => ServiceData.fromJson(json))
            .toList();
        return services;
      }
      return [];
    } catch (e) {
      print(e);
      ;
      return [];
    }
  }

  Future<List<ServiceData>> getBottomServicesByBookings() async {
    try {
      final response = await _dio.get(Endpoints.bottomServicesCount);
      print(response.data);
      if (response.statusCode == 200) {
        List<ServiceData> services = (response.data as List)
            .map((json) => ServiceData.fromJson(json))
            .toList();
        return services;
      }
      return [];
    } catch (e) {
      print(e);
      ;
      return [];
    }
  }

  Future<List<ServiceRevenueData>> getTopServicesByRevenue() async {
    try {
      final response = await _dio.get(Endpoints.topServicesRevenue);
      print(response.data);

      if (response.statusCode == 200) {
        List<ServiceRevenueData> services = (response.data as List)
            .map((json) => ServiceRevenueData.fromJson(json))
            .toList();
        return services;
      }
      return [];
    } catch (e) {
      print(e);
      ;
      return [];
    }
  }
}
