import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:camera_test_web/camera_helper.dart';
import 'package:camera_test_web/camera_photo_gallery_screen.dart';
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
    final controller =
        CameraController(cameraDescriptions![0], ResolutionPreset.max);
    await controller.initialize();
    return controller;
  }

  late final StreamController<Uint8List> capturedImage = StreamController();
  late final Future<CameraController?> _cameraControllerFuture;

  @override
  void initState() {
    _cameraControllerFuture = getCameraController();
    super.initState();
  }

  @override
  void dispose() async {
    capturedImage.close();
    (await _cameraControllerFuture)?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<CameraController?>(
          future: _cameraControllerFuture,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder(
                              stream: capturedImage.stream,
                              builder:
                                  (_, AsyncSnapshot<Uint8List?> imageSnapShot) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CameraPhotoGalleryScreen(),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(19),
                                    child: imageSnapShot.data != null
                                        ? Image.memory(
                                            imageSnapShot.data!,
                                            width: 38,
                                            height: 38,
                                          )
                                        : Icon(
                                            Icons.insert_photo,
                                            size: 38,
                                          ),
                                  ),
                                );
                              }),
                          const SizedBox.shrink(),
                          IconButton(
                            onPressed: () async {
                              final file = await cameraController.takePicture();
                              final bytes = await file.readAsBytes();
                              capturedImage.sink.add(bytes);
                              // final encodedImage = base64Encode(bytes);
                              // encodedImages.add(encodedImage);
                            },
                            icon: Icon(
                              Icons.camera,
                              size: 38,
                            ),
                          ),
                          const SizedBox.shrink(),
                          IconButton(
                            onPressed: () async {
                              //todo implement video recording
                            },
                            icon: Icon(
                              Icons.videocam_outlined,
                              size: 38,
                            ),
                          ),
                        ],
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
