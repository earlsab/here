import 'package:flutter/material.dart';
import 'package:here/screens/group_page.dart';
import 'package:here/screens/events_page.dart';
import 'package:flutter/services.dart';
import 'package:here/functions/globals.dart' as globals;

class NavigationPage extends StatefulWidget {
  final int initialIndex;

  const NavigationPage({super.key, this.initialIndex = 0});

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<NavigationPage> {
  late int _currentIndex;

  final tabs = [
    const GroupPage(),
    const EventsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Force the layout to Portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: tabs[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0), // Adjust as needed
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)), // Adjust as needed
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10), // Adjust as needed
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)), // Adjust as needed
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)), // Adjust as needed
              ),
              child: BottomNavigationBar(
                elevation: 0.0, // This removes the white vertical line
                currentIndex: _currentIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: IconTheme(
                      data: IconThemeData(color: Colors.black), // Change the color as needed
                      child: Icon(Icons.group_outlined),
                    ),
                    label: 'Groups',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.transparent,
                    icon: IconTheme(
                      data: IconThemeData(color: Colors.black), // Change the color as needed
                      child: Icon(Icons.event_outlined),
                    ),
                    label: 'Events',
                  ),
                ],
                onTap: (index) {
                  if (index == 1 && globals.currentGroup == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Choose a group first!')),
                    );
                  } else {
                    setState(() {
                      _currentIndex = index;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}