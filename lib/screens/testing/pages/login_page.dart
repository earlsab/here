import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here/screens/testing/router.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text("Google SignIn"),
          ),
      body: _user != null ? _userInfo() : _googleSignInButton(),
    );
  }

  // TODO: FAILS IF PHONE POPS UP 2 FACTOR VERIFICATION. NEED TO ADD DISCLAIMER ON HOW TO FIX
  Widget _googleSignInButton() {
    return Center(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign In"),
      ),
      body: Center(
        child: SizedBox(
          height: 50,
          child: SignInButton(
            Buttons.google,
            text: "Sign up with Google",
            onPressed: _handleGoogleSignIn,
          ),
        ),
      ),
    ));
  }

  Widget _userInfo() {
    return RouterPage();
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

Widget signoutButton() {
  return Center(
    child: SizedBox(
      height: 50,
      child: SignInButton(
        Buttons.google,
        text: "SIGNOUT",
        onPressed: handleSignout,
      ),
    ),
  );
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

void handleSignout() {
  try {
    _signOut();
  } catch (error) {
    debugPrint(error.toString());
  }
}
