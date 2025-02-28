import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/api/profile/business_profile_api.dart';
import 'package:sklyit_business/models/profile_model/personal_details_model.dart';
import 'package:sklyit_business/providers/business_main.dart';
import '../api/profile/profile_api.dart';
import '../models/profile_model/business_details_model.dart';

final fetchProfileAPI = Provider<ProfileAPIService>((ref) => ProfileAPIService(ref.watch(apiClientProvider).dio));

final userProfileProvider = FutureProvider<PersonalDetailsModel>((ref) async {
  final apiService = ref.watch(fetchProfileAPI);
  return await apiService.fetchProfile();
});

final fetchBusinessAPI = Provider<BusinessProfileAPIService>((ref) => BusinessProfileAPIService(ref.watch(apiClientProvider).dio));

final businessProfileProvider = FutureProvider<BusinessProfile>((ref) async {
  final apiService = ref.watch(fetchBusinessAPI);
  return await apiService.fetchBusinessProfile();
});