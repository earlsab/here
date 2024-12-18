import 'package:flutter/material.dart';
import 'package:here/screens/attendance-screens/list_item.dart';
import 'package:here/screens/create_event.dart';
import 'package:here/screens/edit_event.dart';
import 'package:here/screens/settings.dart';
import 'package:here/functions/globals.dart' as globals;
import 'package:here/functions/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
  void initState() {
    super.initState();
    // Force the layout to Portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: _onBackPressed,
    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            Row(children: [
               Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Events",
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
                    "Current Group: ${globals.currentGroupName}",
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

              const Spacer(), // For space between greeting and buttons

              Column(
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
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            const Divider(color: Color.fromARGB(255, 170, 181, 200)),
            Row(
              // Ongoing Events
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ongoing events",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff153d58),
                        height: 38 / 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  // Create Event button
                  height: 35,
                  width: 35,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CreateEvent()));
                    },
                    backgroundColor: const Color.fromARGB(255, 180, 195, 226),
                    elevation: 1.5,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 20),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: FirestoreService().getEventsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> eventsList = snapshot.data!;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: eventsList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = eventsList[index];
                        String eventID = document.id;

                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('groups')
                              .doc(globals.currentGroup)
                              .collection('events')
                              .doc(eventID)
                              .snapshots(),
                          builder: (context, eventsSnapshot) {
                            if (eventsSnapshot.hasData &&
                                eventsSnapshot.data?.data() != null) {
                              Map<String, dynamic> data = eventsSnapshot.data
                                  ?.data() as Map<String, dynamic>;
                              String eventName = data['eventName'];
                              String eventLocation = data['eventLocation'];
                              String eventDate = data['eventDate'];
                              String eventEnd = data['eventEnd'];
                              String eventStart = data['eventStart'];

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

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Adjust as needed
                                ),
                                child: InkWell(
                                  onTap: () {
                                    globals.currentEvent = document.id;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ItemList(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(0.0), 
                                  child: ListTile(
                                    title: Text(eventName),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Update button
                                        IconButton(
                                          onPressed: () {
                                            globals.currentEvent = document.id;
                                            Navigator.of(context).push(
                                            MaterialPageRoute(
                                               builder: (context) => EditEvent(
                                                   eventName: eventName,
                                                    eventLocation: eventLocation,
                                                    eventDate: eventDate,
                                                    eventStart: eventStart,
                                                    eventEnd: eventEnd,
                                                ) ,
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
                                                title:
                                                    const Text('Delete Event'),
                                                content: const Text(
                                                    'Do you want to delete this event?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      firestoreService
                                                          .deleteEvent(
                                                              document.id);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.delete),
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
          ]),
        ),
      ),
    ),
    );
  }
}
