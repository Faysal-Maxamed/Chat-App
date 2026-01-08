import 'dart:convert';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  List _searchResults = [];
  bool _isLoading = false;

  List get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  SearchProvider();

  Future<void> search(String searchUsers) async {
    try {
      _isLoading = true;
      notifyListeners();
      final box = GetStorage();
      final token = box.read(Token);
      var response = await http.get(
        Uri.parse('$Endpoint/users/search?search=${searchUsers.trim()}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(searchUsers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print("xogta waala soo daabacooyaa");
        print(data);
        // Hubi in xogtu tahay list
        if (data is List) {
          _searchResults = data;
        } else {
          _searchResults = [];
        }

        notifyListeners(); // update UI
      } else {
        print('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during search: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
