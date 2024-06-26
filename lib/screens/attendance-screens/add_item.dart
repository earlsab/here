import 'dart:io';
import 'dart:core';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here/functions/globals.dart';
import 'package:here/main.dart';
import 'package:here/screens/attendance-screens/wait_screen.dart';
import 'package:image_picker/image_picker.dart';

// TODO: MAKE WIDGET REUSABLE
class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerID = TextEditingController();
  TextEditingController _controllerQuantity = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  // CollectionReference _reference =
  //     FirebaseFirestore.instance.collection('attendance');

  final CollectionReference _reference = FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroup)
      .collection('events')
      .doc(currentEvent)
      .collection('attendance');

  String imageUrl = '';
  UploadTask? uploadTask;

  Future uploadFile() async {
    /*
                      * Step 1. Pick/Capture an image   (image_picker)
                      * Step 2. Upload the image to Firebase storage
                      * Step 3. Get the URL of the uploaded image
                      * Step 4. Store the image URL inside the corresponding
                      *         document of the database.
                      * Step 5. Display the image on the list
                      *
                      * */

    /*Step 1:Pick image*/
    //Install image_picker
    //Import the corresponding library
    // TODO: IMPLEMENT IMAGE COMPRESSOR
    ImagePicker imagePicker = ImagePicker();
    // TODO: AWS Has a 5MB Limit. Ensure photo is small in size.
    XFile? file = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    print('${file?.path}');

    if (file == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      setState(() {
        uploadTask = referenceImageToUpload.putFile(File(file.path));
      });

      //Success: get the download URL

      await uploadTask;
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print(imageUrl);
    } catch (error) {
      //Some error occurred
    }

    setState(() {
      uploadTask = null;
    });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });

  @override
  Widget build(BuildContext context) {
    late UploadTask? uploadTask;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerID,
                decoration: InputDecoration(
                  hintText: 'ID Number (e.g. 21-1-12345 or 21112345)',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ID number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerName,
                decoration: InputDecoration(hintText: 'Name/Alias'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () async {
                          uploadFile();
                        },
                        icon: Icon(Icons.camera_alt)),
                  ),
                  SizedBox(width: 50),
                  ElevatedButton(
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          String studentId = _controllerID.text;
                          String alias = _controllerName.text;

                          // String itemQuantity = _controllerQuantity.text;

                          //Create a Map of data
                          if (imageUrl != "") {
                            Map<String, dynamic> dataToSend = {
                              'student-id': studentId,
                              'alias': alias,
                              'image': imageUrl,
                              'verification_status': "for-processing",
                              'recorded_by': auth.currentUser?.email as String,
                              'attendance_status': "IN",
                              'Timestamp_Last_Attendance_Status':
                                  DateTime.now(),
                              'current_group': currentGroup
                            };
                            // Customize the document ID here
                            String customDocumentId = studentId;
                            _reference.doc(customDocumentId).set(dataToSend);
                            Navigator.of(context).pop();
                          } else {
                            // Display toast box error for image not uploaded
                            Fluttertoast.showToast(
                              msg:
                                  'Error: Image not yet uploaded. Please wait for a few more seconds after it has reached 100%',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                            );
                            return;
                          }
                          ;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 95),
                        child: Text('Submit'),
                      )),

                  // progressIndicator(),
                ],
              ),
              buildProgress(),
            ],
          ),
        ),
      ),
    );
  }
}
