import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

    // Save user data to Firestore
   Future<void> addUser(UserCredential userCredential) {
    return FirebaseFirestore.instance
    .collection('users')
    .doc(userCredential.user!.uid)
    .set({
      'uid': userCredential.user!.uid,
      'email': userCredential.user!.email,
      'photoURL': userCredential.user!.photoURL,
    }, SetOptions(merge: true));
  }

  
}

