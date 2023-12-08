import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:here/pages/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google SignIn"),
      ),
      body: Center(
        child: SizedBox(
          width: 230.0, // Set the width of the button
          height: 50.0,
          child: SignInButton(
            Buttons.google,
            onPressed: () async {
              try {
                GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
                UserCredential userCredential = await _auth.signInWithProvider(googleAuthProvider);

                // After successful login, navigate to HomePage
                    if (userCredential.user != null) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
              } catch (error) {
                // Handle error
              }
            },
          ),
        ),
      ),
    );
  }
}