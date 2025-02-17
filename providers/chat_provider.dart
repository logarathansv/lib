import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/providers/business_main.dart';

import '../api/chat/chat_api.dart';
import '../api/chat/get_all_chats.dart';
import '../models/chat_model/chat_message.dart';
import '../models/chat_model/dashboard_model.dart';
import 'package:dash_chat_2/dash_chat_2.dart';


final chatFetchApiProvider = Provider<ChatGetAPIService>((ref) => ChatGetAPIService(ref.read(apiClientProvider).dio));
final chatApiProvider = Provider<ChatAPIService>((ref) => ChatAPIService(ref.read(apiClientProvider).dio));

final chatProvider = FutureProvider.family<List<Message>, String>((ref, otherid) async {
  final apiService = ref.watch(chatFetchApiProvider);
  return await apiService.fetchChats(otherid);
});

final chatProvider2 = FutureProvider<List<ChatDashboard>>((ref) async {
  final apiService = ref.watch(chatFetchApiProvider);
  return await apiService.fetchChats2();
});

final nameProvider = FutureProvider<String>((ref) async {
  final apiService = ref.watch(chatFetchApiProvider);
  return await apiService.fetchName();
});
