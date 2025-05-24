import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sklyit_business/models/business_main/posts_model.dart';
import 'package:sklyit_business/providers/business_main.dart';
import 'post_card.dart';
import 'package:file_picker/file_picker.dart';

class PostsSection extends ConsumerWidget {
  final List<ServicePost> posts;
  final bool isCustomerView;
  File? imageFile;

  PostsSection(
      {super.key, required this.posts, this.isCustomerView = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (posts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No posts available.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Posts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final TextEditingController nameController = TextEditingController();
              final TextEditingController descController = TextEditingController();
              String? imageUrl;
              final apiService = ref.read(businessmainProvider);
              final formKey = GlobalKey<FormState>();
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Create New Post'),
                  content: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: 'Name'),
                            validator: (v) => v == null || v.isEmpty ? 'Enter a name' : null,
                          ),
                          TextFormField(
                            controller: descController,
                            decoration: const InputDecoration(labelText: 'Description'),
                            validator: (v) => v == null || v.isEmpty ? 'Enter a description' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.image),
                                label: const Text('Pick Image'),
                                onPressed: () async {
                                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    imageFile = File(pickedFile.path);
                                  }
                                },
                              ),
                              if (imageFile != null)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.check_circle, color: Colors.green),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await apiService.createPost(
                            name: nameController.text,
                            description: descController.text,
                            imageFile: imageFile!,
                          );
                          ref.invalidate(postServiceProvider); // Invalidate posts list
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Create'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: posts[index],
                isCustomerView: isCustomerView,
                onEdit: () async {
                  final nameController = TextEditingController(text: posts[index].name);
                  final descController = TextEditingController(text: posts[index].description);
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Edit Post'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(labelText: 'Name'),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: descController,
                              decoration: const InputDecoration(labelText: 'Description'),
                              maxLines: 3,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final apiService = ref.read(businessmainProvider);
                              await apiService.editPost(
                                posts[index].id, nameController.text, descController.text,
                              );
                              ref.invalidate(postServiceProvider); // Invalidate posts list
                              Navigator.of(context).pop();
                            },
                            child: const Text('Edit'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Post'),
                        content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmed == true) {
                    final apiService = ref.read(businessmainProvider);
                    await apiService.delPosts(posts[index].id);
                    ref.invalidate(postServiceProvider); // Invalidate posts list
                  }
                }
              );
            },
          ),
        ),
      ],
    );
  }
}
