import 'package:flutter/material.dart';
import 'package:flutter_chat_app/style.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

  class Contact {
    final String name;
    final String phoneNumber;
    final String avatarAsset;

    Contact({
      required this.name,
      required this.phoneNumber,
      required this.avatarAsset,
    });
  }

  List<Contact> sampleContacts = [
    Contact(name: 'John Doe', phoneNumber: '123-456-7890', avatarAsset: 'assets/avatar-2.png'),
    Contact(name: 'Jane Smith', phoneNumber: '987-654-3210', avatarAsset: 'assets/avatar-1.png'),
    Contact(name: 'Syahril Idris', phoneNumber: '123-456-7890', avatarAsset: 'assets/avatar-3.png'),
    Contact(name: 'Lyes Tarzalt', phoneNumber: '987-654-3210', avatarAsset: 'assets/avatar-4.png'),
    Contact(name: 'Ebraiz Syed', phoneNumber: '123-456-7890', avatarAsset: 'assets/avatar-5.png'),
  ];

class _ContactsState extends State<Contacts> {
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
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 20),
                    //   child: RawMaterialButton(
                    //     constraints: const BoxConstraints(minWidth: 0),
                    //     onPressed: () {
                        
                    //     },
                    //     elevation: 2.0,
                    //     fillColor: Colors.transparent,
                    //     padding: const EdgeInsets.all(10.0),
                    //     shape: const CircleBorder(),
                    //     child: const Icon(Icons.more_horiz, size: 18, color: Colors.white),
                    //   ),
                    // ),
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
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: sampleContacts.length,
                    itemBuilder: (context, index) {
                      final contact = sampleContacts[index];
                      return _buildListItem(
                        assetPath: contact.avatarAsset,
                        title: contact.name,
                        text: contact.phoneNumber,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildListItem({
    required String assetPath,
    required String title,
    required String text,
  }) {
    return ListTile(
      leading: Image.asset(
        assetPath,
        width: 48, // Adjust the width as needed
        height: 48, // Adjust the height as needed
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600], // Customize the color here
        ),
      ),
      onTap: () {
        // Handle tap on the contact item
      },
    );
  }

}