import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/api/crm/dashboard_insights_api.dart';
import 'package:sklyit_business/providers/business_main.dart';

final dashboardProvider = Provider<DashBoardAPI>((ref) => DashBoardAPI(ref.read(apiClientProvider).dio));

final getWeeklyCustomerData = FutureProvider((ref) async {
  return ref.read(dashboardProvider).getWeeklyCustomerData();
});

final getMonthlyCustomerData = FutureProvider((ref) async {
  return ref.read(dashboardProvider).getMonthlyCustomerData();
});

final getRetentionRate = FutureProvider((ref) async {
  return ref.read(dashboardProvider).getRetentionStats();
});