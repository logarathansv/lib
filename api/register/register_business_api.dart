import 'package:dio/dio.dart';

import '../endpoints.dart';

class RegisterBusiness{
  final Dio _dio = Dio();

  Future<String> registerBusiness(Map<String, dynamic> registerData) async{
    try{
      final response = await _dio.post(
        '${Endpoints.BASEURL}${Endpoints.register_business}',
        data: registerData
      );
      print(response.data);
      if(response.statusCode == 201 || response.statusCode == 200){
        return 'Business Registered Successfully';
      }else{
        throw Exception('Failed to register business');
      }
    }
    catch(error){
      throw Exception('Failed to register business $error');
    }
  }

  Future<String> checkDomain(String domain) async{
    try{
      final response = await _dio.post(
        '${Endpoints.BASEURL}${Endpoints.check_domain}',
        data: {'domain': domain}
      );
      print(response.data);
      if(response.statusCode == 201 || response.statusCode == 200){
        return 'Domain Available';
      }else{
        throw Exception('Failed to check domain');
      }
    }
    catch(error){
      throw Exception('Failed to check domain $error');
    }
  }
}