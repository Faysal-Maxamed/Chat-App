import 'package:chat_app/Messages/chat_provider.dart';
import 'package:chat_app/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatefulWidget {
  final String receiverId;
  const SendMessage({super.key, required this.receiverId});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController messageController = TextEditingController();
  late ChatProvider chatProvider; // ✅ saxid

  @override
  void initState() {
    super.initState();

    // WidgetsBinding ka dib marka UI dhamaado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.getMessages(widget.receiverId);
      chatProvider.initSocket(); // ✅ xiriir socket samee
    });
  }

  @override
  void dispose() {
    // ✅ xiriirka socket xiro marka aad baxdo page-ka
    chatProvider.disposeSocket();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, LoginController>(
      builder: (context, chatProvider, login, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
            backgroundColor: Colors.blue,
            actions: [
              IconButton(icon: const Icon(Icons.call), onPressed: () {}),
              IconButton(icon: const Icon(Icons.video_call), onPressed: () {}),
            ],
          ),
          body: Column(
            children: [
              // ✅ Messages list
              Expanded(
                child: chatProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final msg = chatProvider.messages[index];
                          final isSender = msg['senderId'] == login.user!.sId;

                          return Align(
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSender
                                    ? Colors.blue[200]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(msg['text'] ?? ''),
                            ),
                          );
                        },
                      ),
              ),

              // ✅ Message input field
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        onChanged: (value) =>
                            chatProvider.getContent(value), // update content
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (messageController.text.trim().isEmpty) return;
                              chatProvider
                                  .sendMessage(widget.receiverId)
                                  .then((_) {
                                messageController.clear();
                              });
                            },
                            icon: const Icon(Icons.send, color: Colors.blue),
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
