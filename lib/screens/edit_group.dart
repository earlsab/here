import 'package:flutter/material.dart';
import 'package:here/screens/text-effects/animate_textfield.dart';
import 'package:here/screens/group_page.dart';
import 'package:random_uuid_string/random_uuid_string.dart';
import 'package:here/functions/firestore.dart';

class EditGroup extends StatefulWidget {
  final String title;

  const EditGroup({super.key, required this.title});

  @override
  State<EditGroup> createState() => _EditGroupState();
  
}

final TextEditingController groupNameController = TextEditingController();
final TextEditingController groupDescriptionController = TextEditingController();

class _EditGroupState extends State<EditGroup> {
  String randomText = RandomString.randomString(length: 6).toUpperCase();

    // Firestore
  final FirestoreService firestoreService = FirestoreService();

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
            Padding(
              padding: const EdgeInsets.only(top: 10.0), 
              child: AnimatedTextField(
                label: "Group Name", 
                suffix: null, 
                controller: groupNameController,
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: AnimatedTextField(
                label: "Group Description", 
                suffix: null, 
                controller: groupDescriptionController,
                ),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity, // Set the width you want here
                child: ElevatedButton(
                  onPressed: () { firestoreService.crudGroup(
                    groupNameController.text, 
                    groupDescriptionController.text, 
                    randomText,
                  );
                  // Clear the text controller
                  groupNameController.clear();
                  groupDescriptionController.clear();
                  
                  // Close the box
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                  builder: (context) => const GroupPage()),
                  );
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF749BC2), 
                  ),
                  child: const Text(
                    'Confirm Details',
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