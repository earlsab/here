import 'package:flutter/material.dart';
import 'package:here/screens/home_page.dart';
import 'package:here/screens/events_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});
  
  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<NavigationPage> {
  int _currentIndex = 0;

  final tabs = [
    const HomePage(),
    const EventsPage(),
  ];


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
                      child: Icon(Icons.home),
                    ),
                    label: 'Home',
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
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}