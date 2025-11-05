import 'package:chat_app/Messages/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context,search,_) {
        return Scaffold(
          appBar: AppBar(title: Text('Search')),
          body: Center(child: Text('Search Page Content')),
        );
      }
    );
  }
}
