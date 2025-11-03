import 'package:chat_app/Messages/chat_provider.dart';
import 'package:chat_app/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatefulWidget {
  final String? receiverId;
  const SendMessage({super.key, required this.receiverId});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.getMessages(widget.receiverId!);
    });
  }

  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, LoginController>(
      builder: (context, chatprovider, login, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(login.user!.phoneNumber ?? '252xx'),
            backgroundColor: Colors.blue,
          ),
          body: Column(
            children: [
             
              Expanded(
                child: chatprovider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: chatprovider.messages.length,
                        itemBuilder: (context, index) {
                          final msg = chatprovider.messages[index];
                          return Align(
                            alignment: msg['isMine'] == true
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: msg['isMine'] == true
                                    ? Colors.blue[100]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(msg['text'] ?? ''),
                            ),
                          );
                        },
                      ),
              ),

              // Input field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) => chatprovider.getContent(value),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () =>
                                chatprovider.sendMessage(widget.receiverId),
                            icon: Icon(Icons.send, color: Colors.blue),
                          ),
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
