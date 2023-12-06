import 'package:flutter/material.dart';
import 'package:here/screens/camera/camera_view.dart';
import 'package:here/screens/camera/camera_widget.dart';
import 'package:here/screens/reusable-pages/add_item.dart';
import 'package:here/screens/reusable-pages/list_item.dart';

class AttendanceSystemTest extends StatelessWidget {
  const AttendanceSystemTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ItemList()));
          },
          child: Text("Hello!"),
        ),
      )),
    );
  }

  Widget informationText() {
    return Center(child: const Text("Prototype (w AWS Integration)"));
  }
}
