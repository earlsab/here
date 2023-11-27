// https://docs.flutter.dev/cookbook/plugins/picture-using-camera
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:here/screens/camera/painters/face_detector_painter.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'dart:ui' as ui;

import 'camera/painters/coordinates_translator.dart';

// Future<void> main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();

//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();

//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;

//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            // print(image.path);

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  List<Face>? faces;

  DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  // var faces;
  Future<ui.Image> loadImage(String imagePath) async {
    final Uint8List data = await File(imagePath).readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  Future<List<Face>?> processFace(InputImage image) async {
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableContours: true,
      enableLandmarks: true,
    );
    final faceDetector = FaceDetector(options: options);
    // logger.d(faces);
    // print(imagePath);
    widget.faces = await faceDetector.processImage(image);
    return widget.faces;
  }

  // var _cameraLensDirection = CameraLensDirection.front;
  @override
  Widget build(BuildContext context) {
    // img.Image? inputImage = img.decodeImage(imageFile.readAsBytesSync());
    InputImage mlImage = InputImage.fromFilePath(widget.imagePath);
    Future<ui.Image?> image = loadImage(widget.imagePath);
    Future<List<Face>?> faces = processFace(mlImage);

    return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: FutureBuilder(
            future: Future.wait([image, faces]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CustomPaint(
                  painter: FacePainter(
                    image: snapshot.data?[0],
                    faces: snapshot.data?[1],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })
        // child: Container(Image.file(File(imagePath))),
        );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image? image;
  final List<Face>? faces;
  final List<Rect> rects = [];

  FacePainter({required this.image, required this.faces}) {
    print(faces);
    if (faces != null) {
      for (var i = 0; i < faces!.length; i++) {
        rects.add(faces![i].boundingBox);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..color = Colors.yellow;

    if (image != null) {
      canvas.drawImage(image!, Offset.zero, Paint());
      for (var i = 0; i < faces!.length; i++) {
        print(rects[i]);
        canvas.drawRect(rects[i], paint);
      }
    } else {
      for (var i = 0; i < faces!.length; i++) {
        print(rects[i]);
        canvas.drawRect(rects[i], paint);
      }
      // canvas.drawRect(rects[i], paint);
      // canvas.drawColor(Colors.white, BlendMode.dst);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
