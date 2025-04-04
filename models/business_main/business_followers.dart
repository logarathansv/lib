class Follower {
  final int followId;
  final int customerId;
  final String followedAt;

  Follower({
    required this.followId,
    required this.customerId,
    required this.followedAt,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      followId: json['followid'],
      customerId: json['customerId'],
      followedAt: json['followedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followid': followId,
      'customerId': customerId,
      'followedAt': followedAt,
    };
  }
}