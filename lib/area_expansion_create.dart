import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class AreaExpansionCreate {
  Future<String> createAndSaveCroppedImage(
    Rect rect,
    Uint8List imageBytes,
  ) async {
    // Load the original image
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage != null) {
      int width = originalImage.width;
      int height = originalImage.height;

      // Crop the image
      img.Image croppedImage =
          img.copyCrop(originalImage, x: 0, y: 0, width: width, height: height);

      // Encode the new image as PNG
      List<int> croppedImageBytes = img.encodePng(croppedImage);

      // Save the image to a file
      String path = (await getTemporaryDirectory()).path;
      File file = File('$path/cropped_image.png');
      await file.writeAsBytes(croppedImageBytes);
      return '$path/cropped_image.png';
    }
    return '';
  }

  Future<void> clearImage() async {
    String path = (await getTemporaryDirectory()).path;
    File file = File('$path/cropped_image.png');
    if (await file.exists()) {
      imageCache.clear();
      imageCache.evict(FileImage(File('$path/cropped_image.png')));
      await file.delete();
      debugPrint('File deleted');
    } else {
      debugPrint('File not found');
    }
  }
}
