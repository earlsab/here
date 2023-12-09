import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE: add a new note
  Future<void> addNote(String note) {
    // Get the current user's
    var userID = _auth.currentUser!.uid;
  
  // Add the note to the 'notes' collection
  return FirebaseFirestore.instance
    .collection('notes')
    .add({
      'note': note,
      'noteCreated': Timestamp.now(),
    })
    .then((docRef) {
      // Add the note ID and role to the 'userRoles' collection
      FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .set({
          'noteRoles': {
            docRef.id: 'creator'
          }
        }, SetOptions(merge: true));
    });
}

  // READ: get notes from Firestore
  Stream<List<DocumentSnapshot>> getNotesStream() {
    // Get the current user's ID
    var userID = _auth.currentUser!.uid;

    // Listen for real-time updates to the user's noteRoles
    return FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .snapshots()
      .asyncMap((snapshot) async {
        // Get the IDs of the notes from noteRoles
        var noteRoles = snapshot.data()?['noteRoles'] as Map<String, dynamic>?;
        var noteIDs = noteRoles?.keys.toList();

        // If there are no such notes, return an empty list
        if (noteIDs == null || noteIDs.isEmpty) {
          return [];
        } else {
          // Query the 'notes' collection for the notes with the obtained IDs
          var notesQuery = FirebaseFirestore.instance
            .collection('notes')
            .where(FieldPath.documentId, whereIn: noteIDs);

          var notesSnapshot = await notesQuery.get();

          // Sort the notes by their 'noteCreated' field
          var docs = notesSnapshot.docs;
          docs.sort((a, b) {
            var aTime = a.data()['noteCreated'] as Timestamp?;
            var bTime = b.data()['noteCreated'] as Timestamp?;
            return bTime?.compareTo(aTime ?? Timestamp.now()) ?? 0;
          });

          return docs;
        }
      });
  }

  // UPDATE: update notes given a doc id
  Future<void> updateNotes(String docID, String newNote) {
    return FirebaseFirestore.instance
      .collection('notes')
      .doc(docID)
      .update({
        'note': newNote,
        'timestamp': Timestamp.now(),
      });
  }

  // SHARE: share a note with another user given their email address
  Future<void> shareNote(String docID, String userEmail,) async {
    // Get the user document with the given email address
    var userDoc = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: userEmail)
      .get();

    // If the user exists
    if (userDoc.docs.isNotEmpty) {
      // Get the user's ID
      var userID = userDoc.docs.first.id;

      // Add the note ID and role to the 'noteRoles' field of the user document
      return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .set({
          'noteRoles': {
            docID: 'moderator'
          }
        }, SetOptions(merge: true));
    } else {
      // If the user does not exist, throw an error
      throw Exception('User does not exist');
      }
  }

  // DELETE: delete a note given a doc id
  Future<void> deleteNote(String docID) async {
    // Get the current user's ID
    var userID = _auth.currentUser!.uid;

    // Start a batch
    var batch = FirebaseFirestore.instance.batch();

    // Delete the note document
    var noteRef = FirebaseFirestore.instance.collection('notes').doc(docID);
    batch.delete(noteRef);

    // Remove the note reference from the 'noteRoles' field of the user document
    var userRef = FirebaseFirestore.instance.collection('users').doc(userID);
    batch.update(userRef, {
      'noteRoles.$docID': FieldValue.delete(),
    });

    // Commit the batch
    return batch.commit();
  }

    // Save user data to Firestore
   Future<void> addUser(UserCredential userCredential) {
    return FirebaseFirestore.instance
    .collection('notes')
    .doc(userCredential.user!.uid)
    .set({
      'email': userCredential.user!.email,
      'uid': userCredential.user!.uid,
      'displayName': userCredential.user!.displayName,
      'photoURL': userCredential.user!.photoURL,
    }, SetOptions(merge: true));
  }
}