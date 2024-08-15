import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class ImagePickerService {
  static const MethodChannel _channel = MethodChannel('image_picker_package');

  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final String? imagePath = await _channel.invokeMethod('pickImage', {'source': source.index});
      if (imagePath != null) {
        return File(imagePath);
      }
    } on PlatformException catch (e) {
      throw Exception('Failed to pick image: ${e.message}');
    }
    return null;
  }
}

enum ImageSource {
  camera,
  gallery,
}
