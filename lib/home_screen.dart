import 'package:camera_test_web/camera_photo_gallery_screen.dart';
import 'package:camera_test_web/camera_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CameraScreen(),
                  ),
                );
              },
              child: const Text('OpenCamera'),
            ),
            const SizedBox(
              height: 24,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CameraPhotoGalleryScreen(),
                  ),
                );
              },
              child: const Text('OpenCameraPhotoGallery'),
            ),
          ],
        ),
      ),
    );
  }
}
