class Message {
  final String id;
  final String sender;
  final String receiver;
  final String content;
  final DateTime timestamp;
  final String sname;
  final String rname;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.timestamp,
    required this.sname,
    required this.rname
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] as String,
      sender: json['senderId'] as String,
      receiver: json['receiverId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sname: json['senderName'] as String,
      rname: json['receiverName'] as String
    );
  }

  // Method to convert a Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'timestamp': timestamp,
      'senderName': sname,
      'receiverName': rname
    };
  }
}