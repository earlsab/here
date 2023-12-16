import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here/functions/globals.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE & UPDATE: add a new group
  Future<void> crudGroup(String groupName, String groupDescription, String groupID) {
    // Get the current user's
    var userID = _auth.currentUser!.uid;

    // Add the group to the 'groups' collection
    return FirebaseFirestore.instance
      .collection('groups')
      .doc(groupID)
      .set({
        'groupName': groupName,
        'groupDescription': groupDescription,
        'groupCreated': Timestamp.now(),
      })
      .then((_) {
        // Add the group ID and role to the 'userRoles' collection
        FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .set({
            'groupRoles': {
              groupID: 'Admin'
            }
          }, SetOptions(merge: true));
      });
  }

  // JOIN: join a group
  Future<void> joinGroup(String groupID) {
    // Get the current user's
    var userID = _auth.currentUser!.uid;

    // Add the group ID and role to the 'userRoles' collection
    return FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .set({
        'groupRoles': {
          groupID: 'Member'
        }
      }, SetOptions(merge: true));
  }

  // CREATE & UPDATE: add a new event
  Future<void> createEvent(String eventName, String eventLocation, String date, String start, String end) {

    // Add the event to the 'events' collection
    return FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroup)
      .collection('events')
      .add({
        'eventName': eventName,
        'eventLocation': eventLocation,
        'eventDate': date,
        'eventStart': start,
        'eventEnd': end,
        'eventCreated': Timestamp.now(),
      },);
  }

  // SHARE: share a group with another user given their email address
  Future<String> shareGroup(String groupID, String userEmail,) async {
    // Get the user document with the given email address
    var userDoc = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: userEmail)
      .get();
    
    // If the user exists
    if (userDoc.docs.isNotEmpty) {
      // Get the user's ID
      var userID = userDoc.docs[0].id;

      // Add the group ID and role to the 'userRoles' collection
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .set({
          'groupRoles': {
            groupID: 'Member'
          }
        }, SetOptions(merge: true));

      return 'User added to the group';
    } else {
      // If the user does not exist, throw an error
      throw Exception('User does not exist');
    }
  }

  // EDIT: edit an event
  Future<void> editEvent(String eventName, String eventLocation, String date, String start, String end) {

    // Edit the event in the 'events' collection
    return FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroup)
      .collection('events')
      .doc(currentEvent)
      .update({
        'eventName': eventName,
        'eventLocation': eventLocation,
        'eventDate': date,
        'eventStart': start,
        'eventEnd': end,
      },);
  }

  // Save user data to Firestore
   Future<void> addUser(UserCredential userCredential) {
    String? name = userCredential.user!.displayName;
    if (name == null && userCredential.user!.email != null) {
    name = userCredential.user!.email!.split('@')[0];
    }
    return FirebaseFirestore.instance
    .collection('users')
    .doc(userCredential.user!.uid)
    .set({
      'uid': userCredential.user!.uid,
      'email': userCredential.user!.email,
      'photoURL': userCredential.user!.photoURL,
      'name': name,
    }, SetOptions(merge: true));
  }

  // READ: get groups from Firestore
  Stream<List<DocumentSnapshot>> getGroupsStream() {
    // Get the current user's ID
    var userID = _auth.currentUser!.uid;

    // Listen for real-time updates to the user's groupRoles
    return FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .snapshots()
      .asyncMap((snapshot) async {
        // Get the IDs of the groups from groupRoles
        var groupRoles = snapshot.data()?['groupRoles'] as Map<String, dynamic>?;
        var groupIDs = groupRoles?.keys.toList();

        // If there are no such groups, return an empty list
        if (groupIDs == null || groupIDs.isEmpty) {
          return [];
        } else {
          // Query the 'groups' collection for the groups with the obtained IDs
          var groupsQuery = FirebaseFirestore.instance
            .collection('groups')
            .where(FieldPath.documentId, whereIn: groupIDs);

          var groupsSnapshot = await groupsQuery.get();

          // Sort the groups by their 'groupCreated' field
          var groupsDocs = groupsSnapshot.docs;
          groupsDocs.sort((a, b) => (b['groupCreated'] as Timestamp).compareTo(a['groupCreated'] as Timestamp));

          return groupsDocs;
        }
      });
  }

  // READ: get events from Firestore
  Stream<List<DocumentSnapshot>> getEventsStream() {
    // Query the 'events' collection for the events with the obtained IDs
    var eventsQuery = FirebaseFirestore.instance
        .collection('groups')
        .doc(currentGroup)
        .collection('events');

    return eventsQuery.snapshots().map((eventsSnapshot) {
      // Sort the events by their 'eventCreated' field
      var eventsDocs = eventsSnapshot.docs;
      eventsDocs.sort((a, b) =>
          (b['eventCreated'] as Timestamp).compareTo(a['eventCreated'] as Timestamp));

      return eventsDocs;
    });
  }

  // DELETE: delete a group given a group id
  Future<void> deleteGroup(String groupID) async {
    // Get the current user's ID
    var userID = _auth.currentUser!.uid;

    // Start a batch
    var batch = FirebaseFirestore.instance.batch();

    // Delete the group document
    var groupRef = FirebaseFirestore.instance.collection('groups').doc(groupID);
    batch.delete(groupRef);

    // Remove the group reference from the 'noteRoles' field of the user document
    var userRef = FirebaseFirestore.instance.collection('users').doc(userID);
    batch.update(userRef, {
      'groupRoles.$groupID': FieldValue.delete(),
    });


    // Commit the batch
    return batch.commit();
  }

    // DELETE: delete an event 
    Future<void> deleteEvent(String eventID) async {
      // Delete the event document
      FirebaseFirestore.instance.collection('groups').doc(currentGroup).collection('events').doc(eventID)
      .delete();
    }
  
}
