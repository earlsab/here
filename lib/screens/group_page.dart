import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:here/screens/create_group.dart';
import 'package:here/screens/edit_group.dart';
import 'package:here/screens/join_group.dart';
import 'package:here/screens/settings.dart';
import 'package:here/functions/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here/functions/globals.dart' as globals;

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

final groupNameController = TextEditingController();
final groupDescriptionController = TextEditingController();

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
            padding: const EdgeInsets.all(15.0),
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
                            "Groups",
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
                      padding: const EdgeInsets.only(left: 2), // Add some space to the left
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
                            'Join Group',
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
                                builder: (context) => const CreateGroup(),
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
                            "Create Group",
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
                  ],
                ),
                const SizedBox(height: 20),
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
                              builder: (context, groupsSnapshot) {
                                if (groupsSnapshot.hasData && groupsSnapshot.data?.data() != null) {
                                  Map<String, dynamic> data = groupsSnapshot.data?.data() as Map<String, dynamic>;
                                  String groupName = data['groupName'];
                                  String groupDescription = data['groupDescription'];
                                  return Card(
                                    color: globals.selectedGroupID == groupID ? Colors.blue : null, // Change color if selected
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15), // Adjust as needed
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          globals.selectedGroupID = groupID; // Update the selected group ID
                                        });
                                        globals.currentGroup = groupID;
                                        globals.currentGroupName = groupName;
                                        
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0), // Adjust the padding as needed
                                        child: ListTile(
                                          title: Text(groupName),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
          // Update button
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
              MaterialPageRoute(
              builder: (context) => EditGroup(
                     groupName: groupName,
                     groupDescription: groupDescription,
                     randomText: groupID,
                   ),
                 ),
               );
            },
            icon: const Icon(Icons.edit),
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
              groupID = globals.currentGroup;
              final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a User'),
        // Text user input
        content: TextField(
          controller: textController,
        ),
        actions: [
          // Button to save
          ElevatedButton(
            onPressed: () async {
              try {
                await firestoreService.shareGroup(globals.currentGroup, textController.text);
                // Clear the text controller
                textController.clear();
                // Close the box
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              } catch (e) {
                // Show the error message in a SnackBar
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
    ),
    ),
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