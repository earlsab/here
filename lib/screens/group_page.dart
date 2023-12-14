import 'package:flutter/material.dart';
import 'package:here/screens/crud_group.dart';
import 'package:here/screens/join_group.dart';
import 'package:here/screens/navigation_menu.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

String title = 'Create Group';

class _GroupPageState extends State<GroupPage> {
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const NavigationPage()),
                      );
                    },
                  ),
                  const Text(
                    'Groups',
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
              child: Text(
                'Groups Joined',
                style: TextStyle(
                  fontFamily: "Helvetica Neue",
                  fontSize: 20, 
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF4682A9)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                child: SizedBox(
                  height: 35,
                child: OutlinedButton(
                  onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const JoinGroup()
                          ),
                          );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                    child: const Text(
                      '+ Join Group',
                      style: TextStyle(
                        fontFamily: "Helvetica Neue",
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        ),
                      ),
                  ),
                ),
                ),
                const SizedBox(width: 10),
                Expanded(
                child: SizedBox(
                  height: 35,
                child: OutlinedButton(
                  onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CrudGroup(title: title),
                          ),
                      );
                  },
                    style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                      ),
                    ), 
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "Helvetica Neue",
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        ),
                      ),
                   ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
