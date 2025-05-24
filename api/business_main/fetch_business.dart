import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sklyit_business/models/business_main/business_main.dart';
import 'package:sklyit_business/models/business_main/posts_model.dart';

import '../endpoints.dart';

class BusinessMainAPI {
  BusinessMainAPI(this._dio);

  final Dio _dio;
  Future<Business> fetchBusiness() async {
    try {
      final response = await _dio.get(Endpoints.business_details);
      if (response.statusCode == 200) {
        return Business.fromJson(response.data['business']);
      } else {
        throw Exception("Failed to load business");
      }
    } catch (error) {
      throw Exception("Failed to load business:$error");
    }
  }

  Future<List<ServicePost>> fetchPosts() async {
    try {
      final response = await _dio.get(Endpoints.getPosts);
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> postsData = response.data as List<dynamic>;

        final List<ServicePost> posts = postsData
            .map((postData) =>
                ServicePost.fromJson(postData as Map<String, dynamic>))
            .toList();

        return posts;
      }

      return [];
    } catch (error) {
      throw Exception("Failed to load posts: $error");
    }
  }

  Future<String> createPost({
    required String name,
    required String description,
    required File imageFile,
  }) async {
    try {
      // String fileName = imageFile.path.split('/').last;

      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        // 'image': await MultipartFile.fromFile(
        //   imageFile.path,
        //   filename: fileName,
        // ),
      });

      final response = await _dio.post(
        Endpoints.createPosts,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Post Created Successfully!";
      } else {
        throw Exception("Failed to create post");
      }
    } catch (error) {
      throw Exception("Failed to create post: $error");
    }
  }

  Future<String> editPost(String id, String name, String description) async {
    try {
      final response = await _dio.put(
        "${Endpoints.editPost}$id",
        data: {'name': name, 'description': description},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Post Updated Successfully!";
      } else {
        throw Exception("Failed to update post");
      }
    } catch (error) {
      throw Exception("Failed to update post:$error");
    }
  }

  Future<String> delPosts(String postid) async {
    try {
      final response = await _dio.delete("${Endpoints.delPost}$postid");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Post Deleted Successfully!";
      } else {
        throw Exception("Failed to delete post");
      }
    } catch (error) {
      throw Exception("Failed to delete post:$error");
    }
  }
}
