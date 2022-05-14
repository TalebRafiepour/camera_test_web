import 'package:camera/camera.dart';
import 'package:camera_test_web/camera_helper.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  ///initialize camera controller
  Future<CameraController?> getCameraController() async {
    final cameraDescriptions = await CameraHelper.getCameras();
    if (cameraDescriptions?.isEmpty ?? true) return null;
    final controller =  CameraController(cameraDescriptions![0], ResolutionPreset.max);
    await controller.initialize();
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<CameraController?>(
          future: getCameraController(),
          builder: (_, AsyncSnapshot<CameraController?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final cameraController = snapshot.data as CameraController;
              return Stack(
                children: [
                  AspectRatio(
                    aspectRatio: size.width / size.height,
                    child: CameraPreview(cameraController),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ElevatedButton(
                        onPressed: () async {
                          final file = await cameraController.takePicture();
                          final bytes = await file.readAsBytes();
                          // final encodedImage = base64Encode(bytes);
                          // encodedImages.add(encodedImage);
                          // setState(() {});
                        },
                        child: Text('Take picture'),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child:
                    Text('error happened when loading camera, look at log plz'),
              );
            }
          }),
    );
  }
}
