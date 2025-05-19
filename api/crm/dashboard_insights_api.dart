import 'package:dio/dio.dart';
import 'package:sklyit_business/api/endpoints.dart';
import 'package:sklyit_business/models/crm_model/dashboard/dashboard_insights.dart';

class DashBoardAPI {
  DashBoardAPI(this._dio);
  final Dio _dio;

  Future<List<WeeklyCustomerData>> getWeeklyCustomerData() async {
    try {
      final response = await _dio.get(Endpoints.customerCountWeekly);
      if (response.statusCode == 200) {
        List<WeeklyCustomerData> weeklyCustomerData = [];
        for (var data in response.data) {
          weeklyCustomerData.add(WeeklyCustomerData.fromJson(data));
        }
        return weeklyCustomerData;
      } else {
        throw Exception(
            'Failed to load weekly customer data'); // Handle the error as needed
      }
    } catch (e) {
      throw Exception(
          'Failed to load weekly customer data'); // Handle the error as needed
    }
  }

  Future<List<MonthlyCustomerData>> getMonthlyCustomerData() async {
    try {
      final response = await _dio.get(Endpoints.customerCountMonthly);
      if (response.statusCode == 200) {
        List<MonthlyCustomerData> monthlyCustomerData = [];
        for (var data in response.data) {
          monthlyCustomerData.add(MonthlyCustomerData.fromJson(data));
        }
        return monthlyCustomerData;
      } else {
        throw Exception(
            'Failed to load monthly customer data'); // Handle the error as needed
      }
    } catch (e) {
      throw Exception(
          'Failed to load monthly customer data'); // Handle the error as needed
    }
  }

  Future<RetentionStats> getRetentionStats() async {
    try {
      final response = await _dio.get(Endpoints.retentionRate);
      if (response.statusCode == 200) {
        return RetentionStats.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load retention stats'); // Handle the error as needed
      }
    } catch (e) {
      throw Exception(
          'Failed to load retention stats'); // Handle the error as needed
    }
  }
}
