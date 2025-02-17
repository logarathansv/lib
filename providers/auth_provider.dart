import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/api/register/register_business_api.dart';

// Create a provider to manage the auth token
final authTokenProvider = StateProvider<String?>((ref) => null);
