import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // // READ: get groups from Firestore
  // Stream<List<DocumentSnapshot>> getGroupsStream() {
  //   // Get the current user's ID
  //   var userID = _auth.currentUser!.uid;

  //   // Listen for real-time updates to the user's groupRoles
  //   return FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(userID)
  //     .snapshots()
  //     .asyncMap((snapshot) async {
  //       // Get the IDs of the groups from groupRoles
  //       var groupRoles = snapshot.data()?['groupRoles'] as Map<String, dynamic>?;
  //       var groupIDs = groupRoles?.keys.toList();

  //       // If there are no such groups, return an empty list
  //       if (groupIDs == null || groupIDs.isEmpty) {
  //         return [];
  //       } else {
  //         // Query the 'groups' collection for the groups with the obtained IDs
  //         var groupsQuery = FirebaseFirestore.instance
  //           .collection('groups')
  //           .where(FieldPath.documentId, whereIn: groupIDs);

  //         var groupsSnapshot = await groupsQuery.get();

  //         // Sort the groups by their 'groupCreated' field
  //         var groupsDocs = groupsSnapshot.docs;
  //         groupsDocs.sort((a, b) => (b['groupCreated'] as Timestamp).compareTo(a['groupCreated'] as Timestamp));

  //         return groupsDocs;
  //       }
  //     });
  // }
  

}

}