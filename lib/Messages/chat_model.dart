class ChatModel {
  final String? id;
  final String senderId;
  final String receiverId;
  final String text;
  final String messageType;
  final String? mediaUrl;
  final String? token;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.messageType = "text",
    this.mediaUrl,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  // ✅ Convert JSON to Model
  
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      messageType: json['messageType'] ?? 'text',
      mediaUrl: json['mediaUrl'],
      token: json['token'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // ✅ Convert Model to JSON (for sending to backend)
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'messageType': messageType,
      'mediaUrl': mediaUrl,
      'token': token,
    };
  }
}
