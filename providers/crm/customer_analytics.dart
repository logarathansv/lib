import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/api/crm/customer_insights_api.dart';
import 'package:sklyit_business/models/crm_model/customer_analytics/customer_analytics_model.dart';
import 'package:sklyit_business/providers/business_main.dart';

final customerAnalytics = Provider<CustomerInsightsApi>((ref) => CustomerInsightsApi(ref.read(apiClientProvider).dio));

final getCustomerInsights = FutureProvider<List<CustomerPercentage>>((ref) async {
  final customerInsights = ref.read(customerAnalytics);
  return await customerInsights.getCustomerInsights();
});

final getTopCustomersByRevenue = FutureProvider<List<CustomerRevenue>>((ref) async {
  final customerInsights = ref.read(customerAnalytics);
  return await customerInsights.getTopCustomersByRevenue();
});

final getBottomCustomersByRevenue = FutureProvider<List<CustomerRevenue>>((ref) async {
  final customerInsights = ref.read(customerAnalytics);
  return await customerInsights.getBottomCustomersByRevenue();
});