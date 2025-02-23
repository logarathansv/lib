import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/providers/business_main.dart';
import '../api/customer/customer_api.dart';
import '../models/customer_model/customer_class.dart';


final getCustomerProvider = FutureProvider<List<Customer>>((ref) async{
  return await CustomerService(ref.watch(apiClientProvider).dio).getCustomers();
});

final customerServiceProvider = FutureProvider<CustomerService>((ref) => CustomerService(ref.watch(apiClientProvider).dio));