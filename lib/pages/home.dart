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
// import 'package:google_nav_bar/google_nav_bar.dart';


class ChatRoomListPage extends StatefulWidget {
  final String token;

  ChatRoomListPage({required this.token});

  @override
  _ChatRoomListPageState createState() => _ChatRoomListPageState();
}

class _ChatRoomListPageState extends State<ChatRoomListPage> 
  with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late List<Widget Function()> _bodyView;
  late ChatService chatService;
  late SearchService searchService;
  List<ChatRoomMessage> chatRooms = [];
  List<ChatRoomMessage> filteredChatRooms = [];
  bool isSearchBarVisible = false;
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    chatService = ChatService(widget.token);
    _tabController = TabController(vsync: this, length: 4);
    _loadChatRooms();
    _bodyView = [
      () => ChatRooms(),
      () => Contacts(widget.token),
      () => const Channels(),
      () => SettingsPage(),
    ];
  }

  Future<void> _loadChatRooms() async {
    try {
      List<ChatRoomMessage> rooms = await chatService.getChatRooms();

      setState(() {
        chatRooms = rooms;
        filteredChatRooms = rooms;
        searchService = SearchService(rooms);
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
    });
  }

  final List<String> _labels = ['Chats', 'Contacts', 'Channels', 'Settings'];

  @override
  Widget build(BuildContext context) {
    List<Widget> _icons = const [
      Icon(Icons.home_outlined),
      Icon(Icons.people),
      Icon(Icons.fullscreen_exit_rounded),
      Icon(Icons.settings)
    ];

    return Scaffold(
      // backgroundColor: const Color(0xFF7863DF),
      body: _bodyView[_selectedIndex](),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 90,
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: Colors.teal.withOpacity(0.1),
            child: TabBar(
              onTap: (x) {
                setState(() {
                  _selectedIndex = x;
                });
              },
              labelColor: Colors.white,
              unselectedLabelColor: Colors.blueGrey,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide.none,
              ),
              tabs: [
                for (int i = 0; i < _icons.length; i++)
                  _tabItem(
                    _icons[i],
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
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      child: TextField(
         onChanged: (searchQuery) {
           _updateFilteredRooms(searchQuery);
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget ChatRooms() {
    return ListView(
        children: [
          Container(
            color: Colors.teal.withOpacity(0.1),
            padding: const EdgeInsets.only(top: 30, left: 20),
            height: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryText(
                      text: 'Welcome Asif Ali',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearchBarVisible = !isSearchBarVisible;
                          });
                        },
                        child: Avatar(
                          avatarUrl: avatarList[0]['avatar'].toString(),
                        ),
                      ),
                      if (isSearchBarVisible)
                        Expanded(
                          child: buildSearchBar(),
                        ),
                      if (!isSearchBarVisible)
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
            height: MediaQuery.of(context).size.height - 170,
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
                              child:  Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      getInitials(room.name), // Placeholder for room image
                                      style: const TextStyle(
                                        color: Colors.white,
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
        // margin: EdgeInsets.all(0),
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
            Text(label, style: TextStyle(fontSize: 10)),
          ],
        ));
  }
}
