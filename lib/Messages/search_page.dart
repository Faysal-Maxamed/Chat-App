import 'package:chat_app/Messages/search_provider.dart';
import 'package:chat_app/Messages/send_message.dart';
import 'package:chat_app/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchProvider>(context, listen: false).search('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, search, n) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: kTextColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Discover People",
              style: GoogleFonts.poppins(
                color: kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          body: Column(
            children: [
              // Premium Search Bar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    onChanged: (value) => search.search(value),
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search by phone or email...',
                      hintStyle: GoogleFonts.poppins(
                        color: kTextLightColor,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: kPrimaryColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),

              // Users List
              Expanded(
                child: search.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: kPrimaryColor),
                      )
                    : search.searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_search_rounded,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No users found",
                              style: GoogleFonts.poppins(
                                color: kTextLightColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: search.searchResults.length,
                        itemBuilder: (context, index) {
                          final user = search.searchResults[index];
                          return _buildUserTile(context, user);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserTile(BuildContext context, dynamic user) {
    final String email = user['email'] ?? 'No Email';
    final String phone = user['phoneNumber'] ?? 'No Phone';
    final String initial = email.isNotEmpty ? email[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: kPrimaryColor.withOpacity(0.1),
          child: Text(
            initial,
            style: GoogleFonts.poppins(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          phone,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kTextColor,
          ),
        ),
        subtitle: Text(
          email,
          style: GoogleFonts.poppins(fontSize: 13, color: kTextLightColor),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: kPrimaryColor,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendMessage(
                    receiverId: user['_id'],
                    receiverPhone: phone,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
