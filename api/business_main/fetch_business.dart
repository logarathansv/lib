import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:sklyit_business/models/business_main/business_main.dart';
import 'package:flutter/services.dart';

import '../endpoints.dart';

class BusinessMainAPI {
    BusinessMainAPI(this._dio);

    final Dio _dio;
    Future<Business> fetchBusiness() async {
      try {
        final response = await _dio.get(
            Endpoints.business_details
        );
        if(response.statusCode == 200){
          return Business.fromJson(response.data['business']);
        }
        else{
          throw Exception("Failed to load business");
        }
      }
      catch(error){
        throw Exception("Failed to load business:$error");
      }
    }
}