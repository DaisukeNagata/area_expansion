import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    super.key,
    required this.imageBytes,
    required this.rect,
    required this.path,
  });

  final Uint8List imageBytes;
  final Rect rect;
  final String path;

  void _shareImage() {
    Share.shareFiles([path]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareImage(),
          ),
        ],
      ),
      body: Center(
        child: Image.memory(imageBytes),
      ),
    );
  }
}
