import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here/screens/navigation_menu.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:here/functions/firestore.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Firestore
  final FirestoreService firestoreService = FirestoreService();

    @override
  void initState() {
    super.initState();
    // Force the layout to Portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // This will exit the app when back button is pressed
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F4EB),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.asset('assets/loginlogo.png', height: 250),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 230.0,
                      height: 50.0,
                      child: SignInButton(
                        Buttons.google,
                        onPressed: () async {
                          try {
                            GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
                            UserCredential userCredential = await _auth.signInWithProvider(googleAuthProvider);

                          // After successful login, navigate to HomePage
                          if (userCredential.user != null) {
                          
                          // Save user data to Firestore
                          firestoreService.addUser(userCredential);

                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NavigationPage()),
                          );
                        }
                          } catch (error) {
                            // Handle error
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: 230.0,
                      child: Text(
                        "By registering in the app, you confirm you accept our Terms of Use and Privacy Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}