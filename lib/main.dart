import 'package:chat_app/Messages/chat_provider.dart';
import 'package:chat_app/Messages/chat_screen.dart';
import 'package:chat_app/Register/register_controller.dart';
import 'package:chat_app/login/login_controller.dart';
import 'package:chat_app/login/login_page.dart';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  var hasdate = box.hasData(isLoggedIn);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => RegisterController()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.white,
      ),
      home:hasdate? ChatScreen(): LoginPage( ),
    ),
    ),
  );
}


