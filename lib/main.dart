import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:here/screens/login_page.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:here/screens/navigation_menu.dart';
import 'firebase_options.dart';

// late List<CameraDescription> cameras;
// List<CameraDescription> cameras = <CameraDescription>[];

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final ValueNotifier<User?> userNotifier = ValueNotifier<User?>(null);

    auth.authStateChanges().listen((User? user) {
      userNotifier.value = user;
    });

    return MaterialApp(
      title: "Here!",
      debugShowCheckedModeBanner: false,
      home: ValueListenableBuilder<User?>(
        valueListenable: userNotifier,
        builder: (BuildContext context, User? user, Widget? child) {
          if (user == null) {
            return const LoginPage();
          } else {
            return const NavigationPage();
          }
        },
      ),
    );
  }
}
