import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {
      'name': 'Mohamed Ali',
      'lastMessage': 'Hey, how are you?',
      'time': '10:45 AM',
    },
    {
      'name': 'Faysal Mohamed',
      'lastMessage': 'Let\'s meet tomorrow',
      'time': '9:30 AM',
    },
    {
      'name': 'ZamZam Abdullahi',
      'lastMessage': 'Check this out!',
      'time': 'Yesterday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueAccent,
              child: Text(
                chat['name']![0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              chat['name']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chat['lastMessage']!),
            trailing: Text(
              chat['time']!,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatRoomScreen(userName: chat['name']!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for new chat
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
