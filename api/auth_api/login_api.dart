import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sklyit_business/api/Order/order_api.dart';
import 'package:sklyit_business/providers/chat_provider.dart';
import 'package:sklyit_business/utils/socket/order_socket_service.dart';
import 'package:sklyit_business/utils/socket/socket_service.dart';
import '../endpoints.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final loginApiProvider = Provider((ref) => LoginAPIService(ref));

class LoginAPIService {
  final Ref ref;
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  LoginAPIService(this.ref);

  Future<String> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await dio.post(
        '${Endpoints.BASEURL}${Endpoints.login}',
        data: {'userid': email, 'password': password},
      );
      if (response.statusCode == 201) {
        prefs.setBool("is_logged", true);
        await storage.write(key: 'token', value: response.data['token']);
        await storage.write(key: 'rtoken', value: response.data['rtoken']);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response.data['rtoken']);
        final uid = decodedToken['sub'].toString();
        await storage.write(key: 'userId', value: uid);
        await ref.read(chatApiProvider).saveAndSendToken(uid);
        SocketService().initialize(uid);
        print("socket service initialized for ${decodedToken['sub']}");
        OrderSocketService().initialize(uid);
        print("order socket service initialized for ${decodedToken['sub']}");
        return 'Login successful';
      }
      print(response.data);
      return 'Failed to login';
    } on DioException catch (error) {
      if (error.response != null) {
        return error.response!.data['message'] ??
            'An error occurred';
      } else {
        print('Error without response: ${error.message}');
        return 'Failed to connect to the server';
      }
    }
    catch (error) {
      throw Exception('Failed to login: $error');
    }
  }
}