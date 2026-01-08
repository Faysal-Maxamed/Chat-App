import 'dart:convert';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/socket/sockets_provider.dart';

class ChatProvider extends ChangeNotifier {
  final socketService = SocketService();
  // socketService.connect();
  final box = GetStorage();
  String? receiverId;
  String? content;

  String? get ReceiverId => receiverId;
  String? get Content => content;
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  // Track online users (user ids)
  Set<String> _onlineUsers = {};

  Set<String> get onlineUsers => _onlineUsers;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

  // ✅ Marka page-ka la furo, ku xiro socket
  void initSocket() {
    socketService.connect();

    socketService.onNewMessage((msg) {
      debugPrint('📩 Socket message received: $msg');
      final senderIdId = msg['senderId'];

      // Only add message if it belongs to the current conversation
      if (receiverId != null &&
          (senderIdId == receiverId || msg['receiverId'] == receiverId)) {
        // Prevent duplicates (e.g. if we are the sender and already added it locally)
        final alreadyExists = _messages.any(
          (m) =>
              m['_id'] == msg['_id'] ||
              (m['text'] == msg['text'] && m['createdAt'] == msg['createdAt']),
        );
        if (!alreadyExists) {
          _messages.insert(
            0,
            msg,
          ); // Add to the TOP of the list (which will be the BOTTOM of the reversed ListView)
          notifyListeners();
        }
      }
    });

    // Listen for online users from server and update set
    socketService.onOnlineUsers((list) {
      _onlineUsers = Set<String>.from(list);
      notifyListeners();
    });
  }

  void disposeSocket() {
    socketService.disconnect();
  }

  getReceiverId(String value) {
    receiverId = value;
    notifyListeners();
  }

  getContent(String value) {
    content = value;
    notifyListeners();
  }

  /// ✅ GET Messages between current user & receiver
  Future<void> getMessages(String receiverId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = box.read(Token);
      final response = await http.get(
        Uri.parse('$Endpoint/messages/$receiverId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Reverse the list so the newest message is at index 0
        _messages = List<Map<String, dynamic>>.from(
          data['messages'],
        ).reversed.toList();
      } else {
        debugPrint('❌ Failed to fetch messages: ${response.body}');
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching messages: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getChatList() async {
    try {
      final token = box.read(Token);
      final hasdate = box.hasData(token);
      print(hasdate);
      final response = await http.get(
        Uri.parse('$Endpoint/messages/chats/list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      print(token);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        debugPrint('❌ Failed to fetch chat list: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching chat list: $e');
      return [];
    }
  }

  /// ✅ HTTP + Socket Send Message
  Future<void> sendMessage(ReceiverID) async {
    try {
      final token = box.read(Token);
      final response = await http.post(
        Uri.parse('$Endpoint/messages/send'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'receiverId': ReceiverID, 'content': content}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];

        // ✅ Add locally at the start (bottom of view)
        _messages.insert(0, data);
        notifyListeners();

        // ✅ Emit through socket for real-time delivery
        socketService.sendMessage(data);
      } else {
        debugPrint('❌ Failed to send message: ${response.body}');
      }
    } catch (e) {
      debugPrint('⚠️ Error sending message: $e');
    }
  }
}
