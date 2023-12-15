import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:here/functions/firestore.dart';
import 'navigation_menu.dart';
import 'dart:async';

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
  Widget build(BuildContext context) {
    return Scaffold(
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

                          if (userCredential.user != null) {
                            await firestoreService.addUser(userCredential);

                            Timer.run(() {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const NavigationPage()),
                              );
                            });
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
    );
  }
}