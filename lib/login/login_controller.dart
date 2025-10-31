import 'dart:convert';

import 'package:chat_app/Messages/chat_screen.dart';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController extends ChangeNotifier {
  String? _phoneNumber;
  String? _password;

  String? get phoneNumber => _phoneNumber;
  String? get password => _password;

  getPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  getPassword(String value) {
    _password = value;
    notifyListeners();
  }

  login(BuildContext context) async {
    try {
      var data = {"phoneNumber": phoneNumber, "password": password};
      var response = await http.post(
        Uri.parse(Endpoint + "users/login"),
        body: jsonEncode(data),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${data}");
      if (response.statusCode == 200) {
        print("succsesfully logged in");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatScreen()),
        );
      }
    } catch (e) {
      print("error during login: $e");
    }
  }
}
