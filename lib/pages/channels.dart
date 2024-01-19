import 'package:flutter/material.dart';
import 'package:flutter_chat_app/style.dart';

class Channels extends StatefulWidget {
  const Channels({super.key});

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
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
                      text: 'Channels',
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
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildListItem(
                      assetPath: 'assets/facebook.png',
                      title: 'Facebook',
                      text: 'Connected',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: _buildDivider(),
                    ),
                    _buildListItem(
                      assetPath: 'assets/instagram.png',
                      title: 'Instagram',
                      text: 'Connected',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: _buildDivider(),
                    ),
                    _buildListItem(
                      assetPath: 'assets/twitter.png',
                      title: 'Twitter',
                      text: '-',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: _buildDivider(),
                    ),
                    _buildListItem(
                      assetPath: 'assets/telegram.png',
                      title: 'Telegram',
                      text: 'Connected',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: _buildDivider(),
                    ),
                    _buildListItem(
                      assetPath: 'assets/whatsapp.png',
                      title: 'WhatsApp',
                      text: 'Connected',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: _buildDivider(),
                    ),
                    _buildListItem(
                      assetPath: 'assets/email.png',
                      title: 'Email',
                      text: '-',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: _buildDivider(),
                    ),
                    _buildListItem(
                      assetPath: 'assets/chatbot.png',
                      title: 'ChatBot',
                      text: '-',
                    ),
                  ],
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
        width: 24,
        height: 24, 
      ),
      title: Text(title),
      trailing: Opacity(
        opacity: 0.7, 
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87, 
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