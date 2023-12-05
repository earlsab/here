import 'package:flutter/material.dart';
import 'package:here/screens/home_page.dart';
import 'package:here/screens/events_page.dart';
import 'package:here/screens/search_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<NavigationPage> {
  int _currentIndex = 0;

  final tabs = [
    HomePage(),
    EventsPage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_outlined), label: 'Events'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), label: 'Search'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
