import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here/functions/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here/screens/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firestore
  final FirestoreService firestoreService = FirestoreService();

  // Text controller
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Text user input
        content: TextField(
          controller: textController,
        ),
        actions: [
          // Button to save
          ElevatedButton(
            onPressed: () {
              // Add a new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }
              // Update existing note
              else {
                firestoreService.updateNotes(docID, textController.text);
              }

              // Clear the text controller
              textController.clear();

              // Close the box
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  void shareNotesDoc({String? docID}) {
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
                await firestoreService.shareNote(docID!, textController.text);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text("Sign Out"),
          ),
        ],
      ),
      body: Column(
        children: [
  StreamBuilder<List<DocumentSnapshot>>(
    stream: firestoreService.getNotesStream(),
    builder: (context, snapshot) {
      // If we have data, get all of the docs
      if (snapshot.hasData) {
        List<DocumentSnapshot> notesList = snapshot.data!;

        // Display as list
        return Expanded(
          child: ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              // Get each individual doc
              DocumentSnapshot document = notesList[index];
              String docID = document.id;
 
              // Use a StreamBuilder to listen for real-time updates to the note
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                  .collection('notes')
                  .doc(docID)
                  .snapshots(),
                  builder: (context, noteSnapshot) {
                    // If we have data and the data is not null, get the note
                    if (noteSnapshot.hasData && noteSnapshot.data?.data() != null) {
                      Map<String, dynamic> data = noteSnapshot.data?.data() as Map<String, dynamic>;
                      String noteText = data['note'];
                        
                    // Display as list tile
                    return ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Update button
                          IconButton(
                            onPressed: () => openNoteBox(docID: docID),
                            icon: const Icon(Icons.settings),
                          ),
                          // Delete button
                          IconButton(
                            onPressed: () => firestoreService.deleteNote(docID),
                            icon: const Icon(Icons.delete),
                          ),
                          // Share button
                          IconButton(
                            onPressed: () => shareNotesDoc(docID: docID),
                            icon: const Icon(Icons.share), 
                          )
                        ],
                      )
                    );
                  } else {
                    // If we don't have data, display a loading indicator
                    return const CircularProgressIndicator();
                  }
                },
              );
            },
          ),
        );
      } else {
        // If we don't have data, display a loading indicator
        return const CircularProgressIndicator();
      }
    },
  ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}