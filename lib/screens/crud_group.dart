import 'package:flutter/material.dart';
import 'package:here/screens/text-effects/animate_textfield.dart';
import 'package:here/screens/group_page.dart';
import 'package:random_uuid_string/random_uuid_string.dart';

class CrudGroup extends StatefulWidget {
  final String title;

  const CrudGroup({Key? key, required this.title}) : super(key: key);

  @override
  State<CrudGroup> createState() => _CrudGroupState();
}

class _CrudGroupState extends State<CrudGroup> {
  String randomText = RandomString.randomString(length: 6).toUpperCase();

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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const GroupPage()),
                      );
                    },
                  ),
                   Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Helvetica Neue", 
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0), 
              child: AnimatedTextField(label: "Group Name", suffix: null),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: AnimatedTextField(label: "Group Description", suffix: null),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10), // This makes the corners rounded
                      ),
                        child: Text(
                          randomText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Helvetica Neue",
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    ),
                  ),
                  const SizedBox(width: 10), // Add some space between the TextField and the Button
                  Expanded(
                    child: SizedBox(
                      height: 55, // Set the height you want here
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            randomText = RandomString.randomString(length: 6).toUpperCase();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF91C8E4), // This sets the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // This makes the corners rounded
                          ),
                        ),
                        child: const Text(
                          'Generate',
                          style: TextStyle(
                            fontFamily: "Helvetica Neue",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16), 
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