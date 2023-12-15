import 'package:flutter/material.dart';
import 'package:here/screens/text-effects/animate_textfield.dart';
import 'package:here/screens/group_page.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(
                        MaterialPageRoute(
                            builder: (context) => const GroupPage()),
                      );
                    },
                  ),
                  const Text(
                    'Join Group',
                    style: TextStyle(
                      fontFamily: "Helvetica Neue", 
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0), 
              child: AnimatedTextField(label: "Group Code", suffix: null),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity, // Set the width you want here
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF749BC2), 
                  ),
                  child: const Text(
                    'Join Group',
                    style: TextStyle(color: Colors.white, fontSize: 16), 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBorderPainter extends  CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}