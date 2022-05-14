import 'dart:html';

import 'package:camera/camera.dart';

abstract class CameraHelper {
  static Future<bool> _grantCameraPermission() async {
    await window.navigator.mediaDevices!
        .getUserMedia({'video': true, 'audio': false});
    return true;
  }

  static Future<List<CameraDescription>?> getCameras() async {
    try {
      await _grantCameraPermission();
      final cameras = await availableCameras();
      return cameras;
    } on DomException catch (e) {
      print('${e.name}: ${e.message}');
    }
  }
}
