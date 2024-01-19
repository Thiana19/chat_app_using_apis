import 'package:flutter/material.dart';
import 'package:flutter_chat_app/style.dart';
import 'package:flutter_chat_app/models/contact_model.dart';
import 'package:flutter_chat_app/services/contact_service.dart';

class Contacts extends StatefulWidget {
  final String token;

  Contacts(this.token);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late List<Contact> contacts = [];

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
      });
    } catch (error) {
      // Handle errors
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 30, left: 20),
          height: 110,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryText(
                    text: 'Contacts',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15, left: 0, right: 10),
          height: MediaQuery.of(context).size.height - 110,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return _buildContactListItem(contact);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactListItem(Contact contact) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blue, // Customize the background color
            child: Text(
              getInitials(contact.name),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
          padding: const EdgeInsets.only(left: 20),
          child: _buildDivider(),
        )
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 1,
    );
  }
}
