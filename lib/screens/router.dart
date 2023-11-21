// https://docs.flutter.dev/cookbook/navigation/navigation-basics
// Routing style from https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/main.dart
import 'package:flutter/material.dart';
import 'package:here/screens/camera.dart';
import 'package:here/screens/camera2.dart';
import 'package:here/screens/second_route.dart';

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Here!'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ExpansionTile(
                    title: const Text('Debugging'),
                    children: [
                      const CustomCard('Second Route Test', SecondRoute()),
                      const CustomCard('Camera', CameraApp()),
                      CustomCard('ML-Kit Implementation', FaceDetectorView()),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ExpansionTile(
                    title: Text('Main'),
                    children: [
                      // CustomCard('Entity Extraction', EntityExtractionView()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const CustomCard(this._label, this._viewPage, {this.featureCompleted = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          _label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (!featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('This feature has not been implemented yet')));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => _viewPage));
          }
        },
      ),
    );
  }
}
