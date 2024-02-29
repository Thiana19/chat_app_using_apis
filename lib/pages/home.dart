import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/channels.dart';
import 'package:flutter_chat_app/pages/contacts.dart';
import 'package:flutter_chat_app/pages/inbox.dart';
import 'package:flutter_chat_app/pages/settings.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_app/constant.dart';
import 'package:flutter_chat_app/services/chat_rooms_service.dart';
import 'package:flutter_chat_app/services/search_service.dart';
import 'package:flutter_chat_app/style.dart';
import 'package:flutter_chat_app/models/chat_room_model.dart';

class ChatRoomListPage extends StatefulWidget {
  final String token;

  ChatRoomListPage({required this.token});

  @override
  _ChatRoomListPageState createState() => _ChatRoomListPageState();
}

class _ChatRoomListPageState extends State<ChatRoomListPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late List<Widget Function()> _bodyView;
  late ChatService chatService;
  late SearchServiceHome searchService;
  List<ChatRoomMessage> chatRooms = [];
  List<ChatRoomMessage> filteredChatRooms = [];
  bool isSearchBarVisible = false;
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late PageController _pageController;
  final List<String> _labels = ['Chats', 'Contacts', 'Channels', 'Settings'];

  @override
  void initState() {
    super.initState();
    chatService = ChatService(widget.token);
    _tabController = TabController(vsync: this, length: 4);
    _loadChatRooms();
    _bodyView = [
      () => ChatRooms(),
      () => Contacts(widget.token),
      () => Channels(widget.token),
      () => SettingsPage(widget.token),
    ];
    _pageController = PageController(initialPage: _selectedIndex);
  }

  Future<void> _loadChatRooms() async {
    try {
      List<ChatRoomMessage> rooms = await chatService.getChatRooms();
      setState(() {
        chatRooms = rooms;
        filteredChatRooms = rooms;
        searchService = SearchServiceHome(rooms);
      });
    } catch (e) {
      print('Error loading chat rooms: $e');
      // Handle error
    }
  }

  String formatTimestamp(String timestampString) {
    DateTime timestamp = DateTime.parse(timestampString);
    return DateFormat.Hm().format(timestamp);
  }

  String getInitials(String name) {
    List<String> nameSplit = name.split(' ');
    String initials = '';
    for (String part in nameSplit) {
      initials += part[0];
    }
    return initials.toUpperCase();
  }

  Color generateAvatarColor(String name) {
    final int hash = name.hashCode;
    final int red = (hash & 0xFF0000) >> 16;
    final int green = (hash & 0x00FF00) >> 8;
    final int blue = hash & 0x0000FF;
    final Color color = Color.fromRGBO(red, green, blue, 1.0);
    return color.withOpacity(0.5);
  }

  Widget channelIcon(String channel) {
    String iconPath;
    switch (channel) {
      case 'facebook':
        iconPath = 'assets/facebook.png';
        break;
      case 'instagram':
        iconPath = 'assets/instagram.png';
        break;
      case 'whatsapp':
        iconPath = 'assets/whatsapp.png';
        break;
      default:
        iconPath = 'assets/message.png';
    }

    return Image.asset(
      iconPath,
      width: 19,
      height: 19,
    );
  }

  void _updateFilteredRooms(String searchQuery) {
    setState(() {
      filteredChatRooms = searchService.searchRooms(searchQuery);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = const [
      Icon(Icons.wechat_outlined),
      Icon(Icons.people),
      Icon(Icons.fullscreen_exit_rounded),
      Icon(Icons.settings)
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          _labels[_selectedIndex], 
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _bodyView.map((widget) => widget()).toList(),
      ),
      bottomNavigationBar: Container(
        // color: Colors.white,
        height: 90,
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: Colors.teal.withOpacity(0.1),
            child: TabBar(
              onTap: _onItemTapped,
              // labelColor: Colors.white,
              // unselectedLabelColor: Colors.blueGrey,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide.none,
              ),
              tabs: [
                for (int i = 0; i < icons.length; i++)
                  _tabItem(
                    icons[i],
                    _labels[i],
                    isSelected: i == _selectedIndex,
                  ),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
      child: TextField(
        onChanged: (searchQuery) {
          _updateFilteredRooms(searchQuery);
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

  // ignore: non_constant_identifier_names
  Widget ChatRooms() {
    return ListView(
      children: [
        const SizedBox(height: 5),
        Container(
          // color: Colors.teal,
          padding: const EdgeInsets.only(left: 15),
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSearchBar(),
              const SizedBox(height: 5),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      key: listKey,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: avatarList.length - 1,
                        itemBuilder: (context, index) {
                          return Avatar(
                            avatarUrl: avatarList[index + 1]['avatar'].toString(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5, left: 0, right: 20),
          height: MediaQuery.of(context).size.height - 150,
          decoration: const BoxDecoration(
            // color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: filteredChatRooms.length,
                  itemBuilder: (context, index) {
                    final room = filteredChatRooms[index];

                    return Column(
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(room.name),
                              Opacity(
                                opacity: 0.4,
                                child: Text(formatTimestamp(room.createdAt)),
                              ),
                            ],
                          ),
                          subtitle: Opacity(
                            opacity: 0.5,
                            child: Text(room.message),
                          ),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundColor: generateAvatarColor(room.name),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    getInitials(room.name),
                                    style: const TextStyle(
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 10,
                                  child: channelIcon(room.channel),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatRoomName: room.name,
                                  token: widget.token,
                                  roomId: room.id,
                                  avatarColor: generateAvatarColor(room.name),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 90),
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
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 1,
    );
  }

  Widget _tabItem(Widget child, String label, {bool isSelected = false}) {
    return AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            child,
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ));
  }
}
