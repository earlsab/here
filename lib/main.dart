import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:here/screens/login_page.dart";
import 'package:here/screens/navigation_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// late List<CameraDescription> cameras;
List<CameraDescription> cameras = <CameraDescription>[];

// Google Cloud Server
final storage = FirebaseStorage.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // INITIALIZE FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print("Firebase initalized successfully!");
  }
  // INITIALIZE CAMERAS
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    if (kDebugMode) {
      print('Camera error: ${e.code}, ${e.description}');
    }
  }

  var host = '192.168.68.103';
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(host, 9150);
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Here!",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Here"),
      ),
      body: const Center(
        child: Text("Test!"),
      ),
    );
  }
}
