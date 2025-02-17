import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sklyit_business/api/endpoints.dart';

class ChatAPIService{
  ChatAPIService(this._dio);
  final Dio _dio;
  final storage = FlutterSecureStorage();

  Future<void> saveAndSendToken(String userId) async {
    final messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    final token = await messaging.getToken();
    updateTokenOnServer(token!, userId);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
    print("fcm $token");
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateTokenOnServer(newToken, userId);
    });
  }

  Future<void> updateTokenOnServer(String token, String userId) async {
    final response = await _dio.put(
      '${Endpoints.users}${Endpoints.notification_update}/$userId',
      data: {
        'fcm_token': token,
      },
    );
    if(response.statusCode == 200 || response.statusCode == 201){
      print('Token Successfully sent to server');
    }
    else{
      print('Failed to sent fcm token');
    }
  }
}