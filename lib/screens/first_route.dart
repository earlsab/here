// https://docs.flutter.dev/cookbook/navigation/navigation-basics

import 'package:flutter/material.dart';
import 'package:here/screens/second_route.dart';

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            child: const Text('Second Route'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondRoute()),
              );
            },
          ),
          const ElevatedButton(
            onPressed: null,
            child: Text('Open route 2'),
          )
        ],
      ),
    );
  }
}
