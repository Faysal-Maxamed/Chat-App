import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  String? _searchusers;
  String? get searchusers => _searchusers;

  List _searchResults = [];
  List get searchResults => _searchResults;

  Search(Searchusers) async {
    try {
      var response = await http.get(
        Uri.parse(Endpoint + "/users/search?search=$Searchusers"),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if(response.statusCode==200){
        
      }
    } catch (e) {}
  }
}
