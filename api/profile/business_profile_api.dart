import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

import '../../models/profile_model/business_details_model.dart';
import '../endpoints.dart';

class BusinessProfileAPIService{
  BusinessProfileAPIService(this.dio);
  final Dio dio;

  Future<BusinessProfile> fetchBusinessProfile() async{
    final response = await dio.get('${Endpoints.business_details}');
    print(response.data);
    if(response.statusCode == 200){
      return BusinessProfile.fromJson(response.data['business']);
    }
    else{
      throw Exception('Failed to load business profile');
    }
  }

  Future<String> updateBusinessProfile(Map<String, dynamic> businessProfile, File? image) async{
    try{
      FormData formdata = FormData.fromMap(businessProfile);
      if (image != null) {
        String? mimeType = lookupMimeType(image.path); // Get MIME type
        List<String>? mimeTypeParts = mimeType?.split('/'); // Split type/subtype

        formdata.files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(
              image.path,
              filename: basename(image.path),
              contentType: mimeTypeParts != null
                  ? MediaType(mimeTypeParts[0], mimeTypeParts[1])
                  : null,
            ),
          ),
        );
      }
      final response = await dio.put(
          '${Endpoints.business_details}',
          data: formdata,
          options: Options(headers: {'Content-Type': 'multipart/form-data'})
      );
      print(response.data);
      if(response.statusCode == 200 || response.statusCode == 201){
        return 'Business Profile Updated Successfully';
      }
      else{
        throw Exception('Failed to update business profile');
      }
    }
    catch(error){
      throw Exception('Failed to update business profile $error');
    }
  }

  Future<String> addAddress(Map<String, dynamic> address) async {
    try {
      final response = await dio.post(
          '${Endpoints.business_details}${Endpoints.add_address}', data: {"address" : address});
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Address Added Successfully';
      }
      else if(response.statusCode == 400){
        return 'Enter a Valid Address';
      }
      else {
        throw Exception('Failed to add address');
      }
    } catch (error) {
      throw Exception('Failed to add address $error');
    }
  }

  Future<String> updateAddress(Map<String, dynamic> address) async {
    try {
      final response = await dio.put(
          '${Endpoints.business_details}${Endpoints.update_address}', data: address);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Address Updated Successfully';
      }
      else {
        throw Exception('Failed to update address');
      }
    } catch (error) {
      throw Exception('Failed to update address $error');
    }
  }

  Future<String> deleteAddress(Map<String, dynamic> address) async {
    try {
      final response = await dio.put(
          '${Endpoints.business_details}${Endpoints.delete_address}', data: address);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Address Deleted Successfully';
      }
      else {
        throw Exception('Failed to delete address');
      }
    } catch (error) {
      throw Exception('Failed to delete address $error');
    }
  }
}