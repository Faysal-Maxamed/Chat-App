import 'package:chat_app/login/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get_storage/get_storage.dart';
import '../themes/constant.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  // final login = Provider.of<LoginController>(context, listen: false);

  SocketService._internal();

  IO.Socket? socket;
  final box = GetStorage();

  // ✅ Connect to Socket.io server
  void connect() {
    final userID = box.read('userId'); // Hadda waa string toos ah
    if (userID == null) {
      print('❌ No user logged in, cannot connect socket');
      return;
    }

    socket = IO.io(
      Endpoint, // e.g. "http://172.30.48.248:4000"
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'userId': userID})
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('✅ Socket connected: ${socket!.id}');
    });

    socket!.onDisconnect((_) {
      print('⚠️ Socket disconnected');
    });

    socket!.onConnectError((data) {
      print('❌ Connection error: $data');
    });
  }

  // ✅ Emit a message
  void sendMessage(Map<String, dynamic> message) {
    socket?.emit('sendNewMessage', message);
  }

  // ✅ Listen for incoming messages
  void onNewMessage(Function(Map<String, dynamic>) callback) {
    socket?.on('newMessage', (data) {
      print('📩 New message received: $data');
      callback(Map<String, dynamic>.from(data));
    });
  }

  // ✅ Listen for online users list from server
  void onOnlineUsers(Function(List<String>) callback) {
    socket?.on('getOnlineUsers', (data) {
      try {
        final list = List<String>.from(data as List);
        print('👥 Online users: $list');
        callback(list);
      } catch (e) {
        print('⚠️ Failed to parse online users: $e');
      }
    });
  }

  // ✅ Disconnect socket when not needed
  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    print('🛑 Socket disconnected manually');
  }
}
