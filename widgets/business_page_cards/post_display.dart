import 'package:flutter/material.dart';
import 'package:sklyit_business/models/business_main/posts_model.dart';

class PostDisplaySection extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> likedBy;
  final List<Comment> comments;
  final DateTime publishedDate;
  final VoidCallback onEdit;

  const PostDisplaySection({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.likedBy,
    required this.comments,
    required this.publishedDate,
    required this.onEdit,
  });

  void _showLikes(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Liked by"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: likedBy.map((user) => ListTile(title: Text(user))).toList(),
          ),
        ),
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: comments
              .map((c) => ListTile(
                    title: Text(c.user, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(c.comment),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Post", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
          ),

          // Image
          Image.network(imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),

          // Name & Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(description),
              ],
            ),
          ),

          // Likes & Published Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Like logic (optional)
                  },
                  onLongPress: () => _showLikes(context),
                  child: Row(
                    children: [
                      const Icon(Icons.thumb_up),
                      const SizedBox(width: 4),
                      Text('${likedBy.length} likes'),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Published on ${publishedDate.day}/${publishedDate.month}/${publishedDate.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Comments Section Button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _showComments(context),
              child: const Text("View Comments"),
            ),
          ),
        ],
      ),
    );
  }
}
