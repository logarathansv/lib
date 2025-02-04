import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/chat_model/chat_message.dart';
import '../../models/chat_model/dashboard_model.dart';
import '../endpoints.dart';

class ChatGetAPIService {
  ChatGetAPIService(this._dio);
  final Dio _dio;
  final storage = FlutterSecureStorage();

  Future<List<Message>> fetchChats(String otherid) async{
    final uid = await storage.read(key: 'userId');
    final response = await _dio.get(
        '${Endpoints.BASEURL}${Endpoints.message}/$uid/$otherid',
    );
    print('got it');
    print(response.data);
    if(response.statusCode == 200){
      List<dynamic> jsonData = response.data;
      return jsonData.map((data) => Message.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed to load chats');
    }
  }

  Future<List<ChatDashboard>> fetchChats2() async{
    final uid = await storage.read(key: 'userId');
    final response = await _dio.get(
        '${Endpoints.message}/$uid'
    );
    print('got it');
    print(response.data);
    if(response.statusCode == 200){
      List<dynamic> jsonData = response.data;
      return jsonData.map((data) => ChatDashboard.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed to load chat2');
    }
  }

  Future<String> fetchName() async{
    final uid = await storage.read(key: 'userId');
    final response = await _dio.get(
        '${Endpoints.users}/e/$uid',
    );
    print(response.data);
    if(response.statusCode == 200){
      return response.data['name'];
    }
    else{
      throw Exception('Failed to load name');
    }
  }
}