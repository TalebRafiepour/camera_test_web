import 'package:flutter/material.dart';

class CameraPhotoGalleryScreen extends StatefulWidget {
  const CameraPhotoGalleryScreen({Key? key}) : super(key: key);

  @override
  _CameraPhotoGalleryScreenState createState() =>
      _CameraPhotoGalleryScreenState();
}

class _CameraPhotoGalleryScreenState extends State<CameraPhotoGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('CameraPhotoGalleryScreen'),
      ),
    );
  }
}
