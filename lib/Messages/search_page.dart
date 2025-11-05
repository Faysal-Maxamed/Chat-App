import 'package:chat_app/Messages/search_provider.dart';
import 'package:chat_app/Messages/send_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, search, n) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) => search.search(value),
                  decoration: InputDecoration(
                    hintText: 'Search Users',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: search.searchResults.length == 0
                      ? Center(child: Text('No results found'))
                      : ListView.builder(
                          itemCount: search.searchResults.length,
                          itemBuilder: (context, index) {
                            final users = search.searchResults[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SendMessage(receiverId: users['_id']),
                                ),
                              ),
                              leading: CircleAvatar(child: Icon(Icons.person)),
                              title: Text(
                                users['phoneNumber'] ?? 'No Phone Number',
                              ),
                              subtitle: Text(users['email'] ?? 'No Email'),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
