import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    super.key,
    required this.imageBytes,
    required this.rect,
  });

  final Uint8List imageBytes;
  final Rect rect;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // Calculate how much the width should be scaled.
    double widthScale = deviceSize.width / rect.width;
    // Calculates how much the height needs to be scaled.
    double heightScale = deviceSize.height / rect.height;
    // The image is scaled to fit either the width or height of the device, preserving the aspect ratio.
    double scale = widthScale < heightScale ? widthScale : heightScale;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: Center(
        child: Transform.scale(
          scale: scale,
          child: Transform.translate(
            offset: Offset(rect.left, rect.top),
            child: Image.memory(imageBytes),
          ),
        ),
      ),
    );
  }
}
