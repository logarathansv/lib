import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider to manage the auth token
final authTokenProvider = StateProvider<String?>((ref) => null);
