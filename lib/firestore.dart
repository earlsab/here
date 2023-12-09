import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here/functions/globals.dart' as globals;

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE: create a group
  Future<void> createGroup(String groupName, String groupCode) async{
    DocumentReference groupRef = await FirebaseFirestore.instance
        .collection('groups')
        .add({
          'groupName': groupName,
          'groupCode': groupCode,
          'groupCreated': Timestamp.now(),
          'members': [_auth.currentUser!.uid]
        });
  }

  // OPEN: open a group
  void openGroup(String groupId) {
    // Update the current group
    globals.currentGroup = groupId;
  }

  // OPEN: open an event
  void openEvent(String eventId) {
    // Update the current event
    globals.currentEvent = eventId;
  }

  // CREATE: add an event
  Future<void> addEvent(String groupName, String eventName) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(globals.currentGroup)
        .collection('events')
        .doc(eventName)
        .set({'eventName': eventName});
  }

  // UPDATE: update a group
  Future<void> updateGroup(String groupName, String groupCode) {
    return FirebaseFirestore.instance
      .collection('groups')
      .doc(globals.currentGroup)
      .update({
        'groupName': groupName,
        'groupCode': groupCode,
      });
  }

  // UPDATE: update an event
  Future<void> updateEvent(String eventName, String eventCode) {
    return FirebaseFirestore.instance
      .collection('groups')
      .doc(globals.currentGroup)
      .collection('events')
      .doc(globals.currentEvent)
      .update({
        'groupName': groupName,
        'groupCode': groupCode,
      });
  }



}
