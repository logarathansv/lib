import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/Service/service_api.dart';
import '../models/service_model/service_model.dart';
import 'business_main.dart';

final getServicesProvider=FutureProvider<List<Service>>((ref) async{
  return await ServiceService(ref.watch(apiClientProvider).dio).getServices();
});