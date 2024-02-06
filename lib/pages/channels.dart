import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/channel_model.dart';
import 'package:flutter_chat_app/services/channel_service.dart';

class Channels extends StatefulWidget {
  final String token;

  Channels(this.token);

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  late List<ChannelModel> channels;

  @override
  void initState() {
    super.initState();
    channels= [];
    _fetchChannels();
  }

  Future<void> _fetchChannels() async {
    try {
      ChannelService channelService = ChannelService(widget.token);
      List<ChannelModel> fetchedChannels = await channelService.getChannels();
      setState(() {
        channels = fetchedChannels;
      });
    } catch (error) {
      print('Error fetching channels: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, left: 0, right: 10),
            height: MediaQuery.of(context).size.height - 110,
            decoration: const BoxDecoration(
              // color: Colors.white,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: channels.length,
                    itemBuilder: (context, index) {
                      ChannelModel channel = channels[index];
                      return Column(
                        children: [
                          _buildListItem(
                            assetPath: 'assets/${channel.name.toLowerCase()}.png',
                            title: channel.name,
                            text: channel.status,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: _buildDivider(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required String assetPath,
    required String title,
    required String text,
  }) {
    return ListTile(
      onTap: () {
        _showChannelInfoDialog(title, text);
      },
      leading: Image.asset(
        assetPath,
        width: 24,
        height: 24,
      ),
      title: Text(title),
      trailing: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: text.toLowerCase() == 'active' ? Colors.teal : Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            // color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showChannelInfoDialog(String title, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: _buildInfoItem('Scicrm', 'Expiring in: Never'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: _buildInfoItem('Wailen Man', 'Expiring in: Never'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: _buildInfoItem('Rara Lens Malaysia ', 'Expiring in: Never'),
            ),
          ],
        ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoItem(String title, String subtitle) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(title),
              const SizedBox(width: 0.43),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Connected',
                  style: TextStyle(
                    // color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 4),
              Text(subtitle),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      // color: Colors.grey[300],
      height: 1,
    );
  }
}
