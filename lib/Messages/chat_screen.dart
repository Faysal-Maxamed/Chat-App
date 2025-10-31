import 'package:chat_app/Messages/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Chat Screen")),
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
                final user = chat['user'];
                final lastMessage = chat['lastMessage'];
                final time = chat['time'];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user['phoneNumber']?.substring(0, 2) ?? 'U'),
                  ),
                  title: Text(user['email'] ?? 'Unknown'),
                  subtitle: Text(lastMessage ?? ''),
                  trailing: Text(
                    time != null
                        ? DateTime.parse(time).toLocal().hour.toString() +
                            ":" +
                            DateTime.parse(time).toLocal().minute.toString()
                        : '',
                  ),
                  onTap: () {
                    // chatProvider.getReceiverId(user['_id']);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => ChatDetailScreen(
                    //       receiverId: user['_id'],
                    //       receiverName: user['email'] ?? 'User',
                    //     ),
                    //   ),
                    // );
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
