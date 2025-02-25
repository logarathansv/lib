import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/models/profile_model/personal_details_model.dart';
import 'package:sklyit_business/providers/business_main.dart';
import '../api/profile/profile_api.dart';

final fetchProfileAPI = Provider<ProfileAPIService>((ref) => ProfileAPIService(ref.watch(apiClientProvider).dio));

// final profileProvider = FutureProvider<PersonalDetailsModel>((ref) async {
//   final apiService = ref.watch(fetchProfileAPI);
//   return await apiService.fetchProfile();
// });

final userProfileProvider = FutureProvider<PersonalDetailsModel>((ref) async {
  final apiService = ref.watch(fetchProfileAPI);
  return await apiService.fetchProfile();
});