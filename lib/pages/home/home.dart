import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pepala/core/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat/chat.dart';
import 'meeting/current_meeting.dart';
import 'profile/profile.dart';
import 'tracker/tracker.dart';

class HomePage extends StatefulWidget {
  final int index;

  const HomePage({Key? key, required this.index}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _currentIndex;

  final List<Widget> _widgetOptions = [
    const CurrentMeetingPage(),
    const TrackerPage(),
    const ProfilePage(),
    const ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatModel()),
      ],
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex ?? widget.index,
          children: _widgetOptions,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          onItemTabbed: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int index) onItemTabbed;

  const CustomBottomNavigationBar({
    Key? key,
    required this.onItemTabbed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: 1,
      height: 60.0,
      items: const [
        Icon(Icons.add, size: 30),
        Icon(Icons.place, size: 30),
        Icon(Icons.person, size: 30),
        Icon(Icons.chat, size: 30),
      ],
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: onItemTabbed,
      letIndexChange: (index) => true,
    );
  }
}
