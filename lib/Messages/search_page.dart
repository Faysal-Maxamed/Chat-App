import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _allUsers = [
    {'name': 'Faysal Mohamed', 'email': 'faysal@gmail.com', 'phone': '1234567890'},
    {'name': 'Abdirizak Ali', 'email': 'abdi@gmail.com', 'phone': '0987654321'},
    {'name': 'Amina Hassan', 'email': 'amina@gmail.com', 'phone': '1122334455'},
  ];
  List<Map<String, String>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _allUsers;
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers.where((user) {
          final emailLower = user['email']!.toLowerCase();
          final phoneLower = user['phone']!;
          final searchLower = query.toLowerCase();
          return emailLower.contains(searchLower) || phoneLower.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search by email or phone...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: _filterUsers,
            ),
          ),
          // List of users
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text('No users found'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(user['name']![0]),
                        ),
                        title: Text(user['name']!),
                        subtitle: Text('${user['email']} | ${user['phone']}'),
                        onTap: () {
                          // Halkan waxaad ku dari kartaa action sida chat u bilaabid
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
