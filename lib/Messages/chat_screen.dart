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
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
 void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.getChatList();
    });
  }
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

                return ListTile(
                  leading: CircleAvatar(child: Text(email.substring(0, 2))),
                  title: Text(phoneNumber),
                  subtitle: Text(lastMessage),
                  trailing: Text(formattedTime),
                  onTap: () {
                    chatProvider.getReceiverId(user['_id'] ?? '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SendMessage(receiverId: user['_id'] ?? '')
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
