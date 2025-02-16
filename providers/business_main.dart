import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/Inventory/product_api.dart';
import '../api/client.dart';
import '../models/product_model/product_model.dart';


final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
//
// final serviceServiceProvider = Provider<ServiceService>((ref) {
//   return ServiceService(ref.watch(apiClientProvider).dio);
// });

final productServiceProvider = FutureProvider<List<Product>>((ref) {
  return ProductService(ref.watch(apiClientProvider).dio).getProducts();
});

// final postServiceProvider = Provider<PostService>((ref) {
//   return PostService(ref.watch(apiClientProvider).dio);
// });
