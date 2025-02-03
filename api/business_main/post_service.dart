import 'package:dio/dio.dart';
import 'dart:io';

class PostService {
  final Dio dio;

  PostService(this.dio);

  // Fetch all posts for the business
  Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await dio.get('/bs/post');
    return List<Map<String, dynamic>>.from(response.data);
  }

  // Create a new post
  Future<Map<String, dynamic>> createPost(
    String title,
    String description,
    File imageFile,
  ) async {
    final formData = FormData.fromMap({
      'name': title,
      'description': description,
      'image': await MultipartFile.fromFile(imageFile.path),
    });

    final response = await dio.post(
      '/bs/posts',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data;
  }

  // Update a post
  Future<Map<String, dynamic>> updatePost(
    String postId,
    String title,
    String description,
  ) async {
    final response = await dio.put(
      '/bs/posts/$postId',
      data: {
        'name': title,
        'description': description,
      },
    );
    return response.data;
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    await dio.put('/bs/posts/$postId');
  }

  // Like a post
  Future<void> likePost(String postId, String userId) async {
    await dio.put(
      '/bs/posts/$postId/like',
      data: {'likedBy': userId},
    );
  }

  // Unlike a post
  Future<void> unlikePost(String postId, String userId) async {
    await dio.put(
      '/bs/posts/$postId/unlike',
      data: {'likedBy': userId},
    );
  }

  // Comment on a post
  Future<void> commentOnPost(
    String postId,
    String userId,
    String comment,
  ) async {
    await dio.put(
      '/bs/posts/$postId/comment',
      data: {'user': userId, 'comment': comment},
    );
  }

  // Uncomment on a post
  Future<void> uncommentOnPost(String postId, String userId) async {
    await dio.put(
      '/bs/posts/$postId/uncomment',
      data: {'user': userId},
    );
  }
}
