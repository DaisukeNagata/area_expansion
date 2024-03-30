import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class AreaExpansionCreate {
  Future<String> createAndSaveCroppedImage(
    Uint8List imageBytes,
    Rect rect,
    Size size,
  ) async {
    // Load the original image
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage != null) {
      // Crop the image. Please allow for some leeway.
      img.Image croppedImage = img.copyCrop(
        originalImage,
        x: rect.left.toInt() + 1,
        y: rect.top.toInt() + 1,
        width: rect.width.toInt() - 2,
        height: rect.height.toInt() - 2,
      );

      // Encode the new image as PNG
      // List<int> croppedImageBytes = img.encodePng(croppedImage);
      img.Image resizedImage = img.copyResize(croppedImage,
          width: size.width.toInt(), height: size.height.toInt());

      List<int> resizedImageBytes = img.encodePng(resizedImage);
      // Save the image to a file
      String path = (await getTemporaryDirectory()).path;
      File file = File('$path/cropped_image.png');
      await file.writeAsBytes(resizedImageBytes);
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
