import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/api/crm/service_insights_api.dart';
import 'package:sklyit_business/models/crm_model/service_insights/service_crm_models.dart';
import 'package:sklyit_business/providers/business_main.dart';

final serviceInsightsProvider = Provider<ServiceInsightsAPI>((ref) => ServiceInsightsAPI(ref.read(apiClientProvider).dio));

final getTopServicesByBookings = FutureProvider<List<ServiceData>>((ref) async {
  final serviceInsightsAPI = ref.watch(serviceInsightsProvider);
  return await serviceInsightsAPI.getTopServicesByBookings();
});
final getBottomServicesByBookings = FutureProvider<List<ServiceData>>((ref) async {
  final serviceInsightsAPI = ref.watch(serviceInsightsProvider);
  return await serviceInsightsAPI.getBottomServicesByBookings();
});

final getTopServicesByRevenue = FutureProvider<List<ServiceRevenueData>>((ref) async {
  final serviceInsightsAPI = ref.watch(serviceInsightsProvider);
  return await serviceInsightsAPI.getTopServicesByRevenue();
});
