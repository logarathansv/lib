import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/Order/order_api.dart';
import '../models/order_model/order_model.dart';
import 'business_main.dart';

final getOrdersProvider=FutureProvider<List<Order>>((ref) async{
  return await OrderService(ref.watch(apiClientProvider).dio).getOrders();
});

final orderServiceProvider = FutureProvider<OrderService>((ref) =>OrderService(ref.watch(apiClientProvider).dio));