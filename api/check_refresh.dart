import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CheckRefreshValid{
  final storage = FlutterSecureStorage();

  Future<bool> isRefreshValid() async {
    final rtoken = await storage.read(key: 'rtoken');
    DateTime expirationDate = JwtDecoder.getExpirationDate(rtoken!);

    DateTime now = DateTime.now();
    print("Expiration (Refresh) : $expirationDate");

    bool isToday = now.year >= expirationDate.year &&
        now.month >= expirationDate.month &&
        now.day >= expirationDate.day;
    if(isToday){
      return false;
    }
    return true;
  }
}