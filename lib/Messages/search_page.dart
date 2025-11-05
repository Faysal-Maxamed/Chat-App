import 'package:chat_app/Messages/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, search, _) {
        return Scaffold(
          appBar: AppBar(
          ),
          body: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search Users',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],),
        );
      },
    );
  }
}
