class ChatDashboard{
  final String userId;
  final String name;

  ChatDashboard({required this.userId, required this.name});

  factory ChatDashboard.fromJson(Map<String, dynamic> json) {
    return ChatDashboard(userId: json['userId'], name: json['name']);
  }
}