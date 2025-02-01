import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/client.dart';
import '../api/service_service.dart';
import '../api/product_service.dart';
import '../api/post_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final serviceServiceProvider = Provider<ServiceService>((ref) {
  return ServiceService(ref.watch(apiClientProvider).dio);
});

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(ref.watch(apiClientProvider).dio);
});

final postServiceProvider = Provider<PostService>((ref) {
  return PostService(ref.watch(apiClientProvider).dio);
});
