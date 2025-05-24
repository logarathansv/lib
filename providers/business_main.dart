import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/api/business_main/fetch_business.dart';
import 'package:sklyit_business/models/business_main/business_main.dart';
import 'package:sklyit_business/models/business_main/posts_model.dart';
import '../api/Inventory/product_api.dart';
import '../api/client.dart';
import '../models/product_model/product_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final businessmainProvider = Provider<BusinessMainAPI>((ref) {
  return BusinessMainAPI(ref.watch(apiClientProvider).dio);
});

final getBusinessProvider = FutureProvider<Business>((ref) async{
  final apiService = ref.watch(businessmainProvider);
  return await apiService.fetchBusiness();
});

final postServiceProvider = FutureProvider<List<ServicePost>>((ref) async {
  final apiService = ref.watch(businessmainProvider);
  return await apiService.fetchPosts();
});
