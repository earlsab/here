import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class BottomSheets extends StatelessWidget {
  const BottomSheets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Text("LogIn/SignUp"),
              onTap: () {
                _displayBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _displayBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => _buildSignInBottomSheet(context),
    );
  }

  Widget _buildSignInBottomSheet(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: SignInButton(
        Buttons.google,
        text: "Sign in with Google",
        onPressed: () {
          _handleGoogleSignIn(context);
        },
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithProvider(googleAuthProvider);
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

class BottomSheet extends StatefulWidget {
  const BottomSheet({super.key}); // Convert 'key' to super parameter

  @override
  State<BottomSheet> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BottomSheet> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        // Add any necessary logic when auth state changes
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
