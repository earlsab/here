import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:here/pages/login_page.dart';
import 'firebase_options.dart';

// late List<CameraDescription> cameras;
List<CameraDescription> cameras = <CameraDescription>[];

Future <void> main() async {
  // INITIALIZE CAMERAS
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    if (kDebugMode) {
      print('Camera error: ${e.code}, ${e.description}');
    }
  }
  // INITIALIZE FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print("Firebase initalized successfully!");
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
