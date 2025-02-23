import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

import '../../models/profile_model/personal_details_model.dart';
import '../endpoints.dart';

class ProfileAPIService{
  ProfileAPIService(this.dio);
  final Dio dio;
  final storage = FlutterSecureStorage();

  Future<PersonalDetailsModel> fetchProfile() async {
    final uid = await storage.read(key: 'userId');
    final response = await dio.get('${Endpoints.get_personal_details}/$uid');
    print(response.data);
    if(response.statusCode == 200){
      return PersonalDetailsModel.fromJson(response.data);
    }
    else{
      throw Exception('Failed to load profile');
    }
  }

  Future<String> updateProfile(Map<String, dynamic> data, File? image) async {
    final uid = await storage.read(key: 'userId');

    FormData formData = FormData.fromMap(data);
    if (image != null) {
      String? mimeType = lookupMimeType(image.path); // Get MIME type
      List<String>? mimeTypeParts = mimeType?.split('/'); // Split type/subtype

      formData.files.add(
        MapEntry(
          'image',
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
        '${Endpoints.update_personal_details}/$uid',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        )
    );
    print(response.data);
    if(response.statusCode == 200 || response.statusCode == 201){
      return 'Profile Updated Successfully';
    }
    else{
      throw Exception('Failed to update profile');
    }
  }
}