import 'package:chat_app/Messages/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatefulWidget {
  final String? receiverId;
  const SendMessage({super.key,required this.receiverId});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatprovider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
            backgroundColor: Colors.blue,
          ),
          body: Column(
            children: [
              // Message list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Text("Messages will appear here");
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
                            onPressed: () => chatprovider.sendMessage(widget.receiverId),
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
