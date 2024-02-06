import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/contact_model.dart';
import 'package:flutter_chat_app/services/contact_service.dart';
import 'package:flutter_chat_app/services/search_service.dart';

class Contacts extends StatefulWidget {
  final String token;

  Contacts(this.token);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late List<Contact> contacts = [];
  late List<Contact> filteredContacts = [];

  SearchServiceContact searchService = SearchServiceContact([]);

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    try {
      final ContactService contactService = ContactService(widget.token);
      final List<Contact> fetchedContacts = await contactService.getContacts();

      setState(() {
        contacts = fetchedContacts;
        filteredContacts = contacts; 
        searchService = SearchServiceContact(contacts);
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    int numWords = names.length >= 2 ? 2 : names.length;

    for (int i = 0; i < numWords; i++) {
      initials += names[i][0].toUpperCase();
    }

    return initials;
  }

  void _updateFilteredContacts(String searchQuery) {
    setState(() {
      filteredContacts = searchService.searchContacts(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 5),
          Container(
            // color: Colors.teal,
            padding: const EdgeInsets.only(left: 15),
            height: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSearchBar(),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15, left: 0, right: 10),
            height: MediaQuery.of(context).size.height - 110,
            
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return _buildContactListItem(contact);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactListItem(Contact contact) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          leading: const CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.teal,
            child: Icon(
              Icons.person,
              size: 36,
              // color: Colors.white,
            ),
            // Text(
            //   getInitials(contact.name),
            //   style: const TextStyle(
            //     fontSize: 20,
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
          title: Text(contact.name),
          subtitle: Text(contact.handle),
          trailing: Opacity(
            opacity: 0.7,
            child: Text(contact.channel),
          ),
          onTap: () {
            // Handle tap on the contact item
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 90),
          child: _buildDivider(),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
      child: TextField(
        onChanged: (searchQuery) {
          _updateFilteredContacts(searchQuery);
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 1,
    );
  }
}
