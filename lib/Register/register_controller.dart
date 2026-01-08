import 'dart:convert';

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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  register(BuildContext context) async {
    if (phoneNumber == null || email == null || password == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: kErrorColor,
        ),
      );
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      var data = {
        "phoneNumber": phoneNumber,
        "email": email,
        "password": password,
      };
      var response = await http.post(
        Uri.parse("$Endpoint/users/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully registered! Please login."),
            backgroundColor: kSuccessColor,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration failed: ${response.body}"),
            backgroundColor: kErrorColor,
          ),
        );
      }
    } catch (e) {
      print("error during registration: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: kErrorColor),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
