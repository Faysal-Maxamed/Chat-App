import 'dart:convert';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  List _searchResults = [];
  List get searchResults => _searchResults;

  Future<void> search(String searchUsers) async {
    try {
      var response = await http.get(
        Uri.parse('$Endpoint/users/search?search=$searchUsers'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

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
    }
  }
}
