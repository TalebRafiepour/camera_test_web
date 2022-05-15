import 'dart:convert';

import 'package:camera_test_web/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CameraPhotoGalleryScreen extends StatefulWidget {
  const CameraPhotoGalleryScreen({Key? key}) : super(key: key);

  @override
  _CameraPhotoGalleryScreenState createState() =>
      _CameraPhotoGalleryScreenState();
}

class _CameraPhotoGalleryScreenState extends State<CameraPhotoGalleryScreen> {
  late final Future<Box<String>> hiveBox;

  @override
  void initState() {
    if (!Hive.isBoxOpen(Constants.cameraPhotoBoxName))
      hiveBox = Hive.openBox(Constants.cameraPhotoBoxName);
    else
      hiveBox = Future.value(Hive.box(Constants.cameraPhotoBoxName));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Images Gallery'),),
      body: FutureBuilder<Box<String>>(
        future: hiveBox,
        builder: (_, AsyncSnapshot<Box<String>> snapShotBox) {
          if (snapShotBox.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapShotBox.connectionState == ConnectionState.done &&
              snapShotBox.hasData) {
            final imagesByte = snapShotBox.data!.values.toList();
            final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 5);

            return GridView.builder(
              gridDelegate: gridDelegate,
              itemCount: imagesByte.length,
              itemBuilder: (_, index) {
                return Image.memory(
                  base64Decode(imagesByte[index]),
                );
              },
            );
          } else {
            return Center(
              child: Text('Error: ${snapShotBox.error}'),
            );
          }
        },
      ),
    );
  }
}
