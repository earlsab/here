// https://docs.flutter.dev/cookbook/navigation/navigation-basics
// Routing style from https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:here/main.dart';
import 'package:here/screens/camera/camera_ml_kit.dart';
import 'package:here/screens/navigation_menu.dart';
import 'package:here/screens/testing/attendance_system_test.dart';
import 'package:here/screens/testing/camera_test.dart';
import 'package:here/screens/second_route.dart';
import 'package:here/screens/testing/pages/login_page.dart';
import 'package:here/screens/home_page.dart';
import 'package:here/widgets/custom_card.dart';

class RouterPage extends StatelessWidget {
  const RouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Here! - Debug Menu'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              ExpansionTile(
                title: const Text('Debugging'),
                children: [
                  const CustomCard('Second Route Test', SecondRoute()),
                  // const CustomCard('Camera', CameraApp()),
                  CustomCard('ML-Kit Implementation', FaceDetectorView()),
                  CustomCard(
                      'Camera Save',
                      TakePictureScreen(
                        camera: cameras.first,
                      )),
                  CustomCard('Attendance System Prototype (w AWS Integration)',
                      AttendanceSystemTest()),
                  // CustomCard('Home', HomeScreen())
                ],
              ),
              ExpansionTile(
                title: Text('Main'),
                children: [
                  CustomCard("Front End", NavigationPage()),
                ],
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text("Logged in as ${auth.currentUser?.email}")),
              ),
              signoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
