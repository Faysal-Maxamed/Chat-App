import 'package:chat_app/Messages/chat_provider.dart';
import 'package:chat_app/Messages/search_page.dart';
import 'package:chat_app/Messages/send_message.dart';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Messages",
          style: GoogleFonts.poppins(
            color: kTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: kBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              ),
              icon: const Icon(Icons.search_rounded, color: kTextColor),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOnlineUsers(chatProvider),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: chatProvider.getChatList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: kPrimaryColor),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 64,
                              color: kTextLightColor.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No conversations yet",
                              style: GoogleFonts.poppins(
                                color: kTextLightColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final chatList = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          final chat = chatList[index];
                          final user = chat['user'] ?? {};
                          final lastMessage = chat['lastMessage'] ?? '';
                          final timeStr = chat['time'] ?? '';
                          final phoneNumber = user['phoneNumber'] ?? 'Unknown';
                          final email = user['email'] ?? 'U';
                          final userId = user['_id'] ?? '';
                          final isOnline = chatProvider.onlineUsers.contains(
                            userId,
                          );

                          String formattedTime = '';
                          if (timeStr.isNotEmpty) {
                            try {
                              final dt = DateTime.parse(timeStr).toLocal();
                              final now = DateTime.now();
                              if (dt.day == now.day &&
                                  dt.month == now.month &&
                                  dt.year == now.year) {
                                formattedTime =
                                    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                              } else {
                                formattedTime = '${dt.day}/${dt.month}';
                              }
                            } catch (_) {}
                          }

                          return _buildChatTile(
                            context,
                            chatProvider,
                            userId,
                            email,
                            phoneNumber,
                            lastMessage,
                            formattedTime,
                            isOnline,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineUsers(ChatProvider chatProvider) {
    // This would typically be a list of all users, filtered by online status
    // For now, we'll show a placeholder or just a label if we don't have all users
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Online Now",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kTextLightColor,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chatProvider.onlineUsers.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kPrimaryColor,
                              width: 2,
                              style: BorderStyle.none,
                            ),
                          ),
                          child: const Icon(Icons.add, color: kPrimaryColor),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 22.5,
                        backgroundColor: kSecondaryColor.withOpacity(0.2),
                        child: Text(
                          "U", // Placeholder since we only have IDs in onlineUsers set
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: kSuccessColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    ChatProvider chatProvider,
    String userId,
    String email,
    String phoneNumber,
    String lastMessage,
    String time,
    bool isOnline,
  ) {
    return InkWell(
      onTap: () {
        chatProvider.getReceiverId(userId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SendMessage(receiverId: userId, receiverPhone: phoneNumber),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: kPrimaryColor.withOpacity(0.1),
                  child: Text(
                    (email.length >= 2)
                        ? email.substring(0, 2).toUpperCase()
                        : email.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: kSuccessColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        phoneNumber,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      Text(
                        time,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: kTextLightColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: kTextLightColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
