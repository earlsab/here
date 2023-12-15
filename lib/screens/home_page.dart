import 'package:flutter/material.dart';
import 'package:here/screens/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, Earlanfdfdsfds!",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Helvetica Neue",
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff4682a9),
                            height: 44/30,
                          ),
                          textAlign: TextAlign.left
                        ),
                        Text(
                          "Viewing as SU/CCS (Member)",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Helvetica Neue",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4682a9),
                            fontStyle: FontStyle.italic,
                            height: 14/15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Container(width: 50), // Fixed space between greeting and buttons
                  Padding(
                    padding: const EdgeInsets.only(left: 0), // Add some space to the left
                    child: Column( // Settings button
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Color.fromARGB(255, 41, 112, 150),
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Rest of the code...
            ],
          ),
        ),
      ),
    );
  }
}