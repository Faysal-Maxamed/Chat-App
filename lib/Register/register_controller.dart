import 'dart:convert';

import 'package:chat_app/Messages/chat_screen.dart';
import 'package:chat_app/login/login_page.dart';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterController extends ChangeNotifier {
  String? _phoneNumber;
  String? _password;
  String? _email;
  String? get phoneNumber => _phoneNumber;
  String? get password => _password;
  String? get email => _email;

  getPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  getPassword(String value) {
    _password = value;
    notifyListeners();
  }

  getEmail(String value) {
    _email = value;
    notifyListeners();
  }

  register(BuildContext context) async {
    try {
      var data = {
        "phoneNumber": phoneNumber,
        "email": email,
        "password": password,
      };
      var response = await http.post(
        Uri.parse(Endpoint + "users/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${data}");
      if (response.statusCode == 201) {
        print("succsesfully registered please login");
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
      }
    } catch (e) {
      print("error during login: $e");
    }
  }
}
