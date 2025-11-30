import 'package:chat_app/Messages/chat_provider.dart';
import 'package:chat_app/Messages/search_page.dart';
import 'package:chat_app/Messages/send_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.initSocket();
      chatProvider.getChatList();
    });
  }

  @override
  void dispose() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.disposeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // listen true so UI updates when online status changes
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Screen"),
      actions: [IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchPage())), icon: Icon(Icons.search))],),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: chatProvider.getChatList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chat list'));
          } else {
            final chatList = snapshot.data!;
            return ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                final user = chat['user'] ?? {};

                final lastMessage = chat['lastMessage'] ?? '';
                final timeStr = chat['time'] ?? '';
                final phoneNumber = user['phoneNumber'] ?? 'U';
                final email = user['email'] ?? 'Unknown';

                String formattedTime = '';
                if (timeStr.isNotEmpty) {
                  try {
                    final dt = DateTime.parse(timeStr).toLocal();
                    formattedTime =
                        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  } catch (_) {
                    formattedTime = '';
                  }
                }

                final userId = user['_id'] ?? '';
                final isOnline = chatProvider.onlineUsers.contains(userId);
                final statusColor = isOnline ? Colors.green : Colors.grey;

                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(child: Text((email.length >= 2) ? email.substring(0, 2) : email)),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(phoneNumber),
                  subtitle: Text(lastMessage),
                  trailing: Text(formattedTime),
                  onTap: () {
                    chatProvider.getReceiverId(userId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SendMessage(receiverId: userId)
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
