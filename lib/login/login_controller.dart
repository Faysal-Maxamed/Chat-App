import 'dart:convert';

import 'package:chat_app/Messages/chat_screen.dart';
import 'package:chat_app/login/login_model.dart';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginController extends ChangeNotifier {
  String? _phoneNumber;
  String? _password;

  LoginModel? user;
  final box = GetStorage();

  LoginController() {
    getuser();
  }

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
        Uri.parse(Endpoint + "/users/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${data}");
      if (response.statusCode == 200) {
        print("succsesfully logged in");
        var decodedate = jsonDecode(response.body);
        var user = LoginModel.fromJson(decodedate);

        print(user.token);
        saveUser(user);
        SnackBar(content: Text("Succsess"));
        print(user.email);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatScreen()),
        );
      }
    } catch (e) {
      print("error during login: $e");
    }
  }

  saveUser(LoginModel login) {
    box.write(userInfo, login.toJson());
    box.write(isLoggedIn, "isLoggedIn");
    box.write(Token, login.token);
    box.write('userId', login.sId);
    print("💾 Token saved to GetStorage: ${login.token}");
  }

  getuser() {
    bool hasdate = box.hasData(userInfo);
    if (hasdate == true) {
      var date = box.read(userInfo);
      user = LoginModel.fromJson(date);
      notifyListeners();
    } else {
      return null;
    }
  }
}
