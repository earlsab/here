import 'package:flutter/material.dart';
import 'package:here/screens/camera/camera_view.dart';
import 'package:here/screens/camera/camera_widget.dart';
import 'package:here/screens/reusable-pages/add_item.dart';

class AttendanceSystemTest extends StatelessWidget {
  const AttendanceSystemTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance System',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(children: [
        informationText(),
        // const CameraApp(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItem()),
          );
        },
      ),
    );
  }

  Widget informationText() {
    return Center(child: const Text("Prototype (w AWS Integration)"));
  }
}
