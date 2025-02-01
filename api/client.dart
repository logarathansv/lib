import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(baseUrl: 'http://192.168.144.41:3000')) {
    _init();
  }

  Future<void> _init() async {
    final directory = await getTemporaryDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage('${directory.path}/.cookies/'),
      persistSession: true,
    );

    dio.interceptors.addAll([
      CookieManager(cookieJar),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            // Add your logout logic here
          }
          return handler.next(e);
        },
      ),
    ]);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
