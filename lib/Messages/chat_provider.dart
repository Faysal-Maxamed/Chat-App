import 'dart:convert';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  final box = GetStorage();
  String? receiverId;
  String? content;

  String? get ReceiverId => receiverId;
  String? get Content => content;
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

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
        _messages = List<Map<String, dynamic>>.from(data['messages']);
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
      final token =box.read(Token);
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

  /// ✅ Send a new message
  Future<void> sendMessage(ReceiverID) async {
    try {
      final token = box.read(Token);

      print(Token);
      final response = await http.post(
        Uri.parse('$Endpoint/messages/send'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'receiverId': ReceiverID, 'content': content}),
      );

      print(response.body);
      print(ReceiverID);
      print("success");
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _messages.add(
          data['data'],
        ); // ✅ sax: backend wuxuu soo diraa data: message
        notifyListeners();
      } else {
        debugPrint('❌ Failed to send message: ${response.body}');
      }
    } catch (e) {
      debugPrint('⚠️ Error sending message: $e');
    }
  }
}
