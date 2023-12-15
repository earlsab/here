import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:here/screens/crud_group.dart';
import 'package:here/screens/join_group.dart';
import 'package:here/screens/navigation_menu.dart';
import 'package:here/screens/settings.dart';
import 'package:here/functions/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

String title = 'Create Group';

class _GroupPageState extends State<GroupPage> {
  // Firestore
  final FirestoreService firestoreService = FirestoreService();

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope( 
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 228, 228, 228),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left
              children: [
                Row(
                  children: [
                     Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome!",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Helvetica Neue",
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff4682a9),
                              height: 44 / 30,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser?.email ?? 'No email',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Helvetica Neue",
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff4682a9),
                              fontStyle: FontStyle.italic,
                              height: 14 / 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Container(width: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 0), // Add some space to the left
                      child: Column(
                        // Settings button
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
                const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    'Groups Joined',
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF4682A9),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Aligns children to the left
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 35,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const JoinGroup(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.transparent,
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
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.transparent,
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
StreamBuilder<List<DocumentSnapshot>>(
  stream: firestoreService.getGroupsStream(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      List<DocumentSnapshot> groupsList = snapshot.data!;

      return Expanded(
        child: ListView.builder(
          itemCount: groupsList.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = groupsList[index];
            String groupID = document.id;

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(groupID)
                .snapshots(),
              builder: (context, noteSnapshot) {
                if (noteSnapshot.hasData && noteSnapshot.data?.data() != null) {
                  Map<String, dynamic> data = noteSnapshot.data?.data() as Map<String, dynamic>;
                  String groupName = data['groupName'];

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => NavigationMenu(
                      //       groupName: groupName,
                      //       groupDescription: groupDescription,
                      //       groupCode: groupCode,
                      //       groupCreated: groupCreated,
                      //       groupRole: groupRole,
                      //       groupID: groupID,
                      //     ),
                      //   ),
                      // );

                    return ListTile(
                    title: Text(groupName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => CrudGroup(
                            //       title: 'Update Group',
                            //       groupName: groupName,
                            //       groupDescription: groupDescription,
                            //       groupCode: groupCode,
                            //       groupCreated: groupCreated,
                            //       groupRole: groupRole,
                            //       groupID: groupID,
                            //     ),
                            //   ),
                            // );
                          },
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Group'),
                                content: const Text('Do you want to delete this group?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      firestoreService.deleteGroup(groupID);
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () {
                            // Add your share functionality here
                          },
                          icon: const Icon(Icons.share),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  },
)
              ]
            )
          )
        )
      )
    );
  }
}