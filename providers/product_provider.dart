import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/models/product_model/product_model.dart';
import 'package:sklyit_business/providers/business_main.dart';
import '../api/Inventory/product_api.dart';

final getProductsProvider=FutureProvider<List<Product>>((ref) async{
  return await ProductService(ref.watch(apiClientProvider).dio).getProducts();
});

