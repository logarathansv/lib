class Comment {
  final String user;
  final String comment;

  Comment({required this.user, required this.comment});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'comment': comment,
    };
  }
}

class ServicePost {
  final String id;
  final String name;
  final String description;
  final String businessId;
  final int likes;
  final List<String> likedBy;
  final List<Comment> comments;
  final String? image;
  final DateTime updatedAt;

  ServicePost({
    required this.id,
    required this.name,
    required this.description,
    required this.businessId,
    required this.likes,
    required this.likedBy,
    required this.comments,
    this.image,
    required this.updatedAt,
  });

  factory ServicePost.fromJson(Map<String, dynamic> json) {
    return ServicePost(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      businessId: json['business_id'] ?? '',
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      image:
          json['image']?.trim().isEmpty == true ? null : json['image']?.trim(),
      comments: json['comments'] != null
          ? List<Comment>.from(json['comments'].map((x) => Comment.fromJson(x)))
          : [],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
