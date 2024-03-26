import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:area_expansion_example/create_image_screen.dart';
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
    Share.shareFiles([path], text: 'Check out this image!');
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double widthScale = deviceSize.width / rect.width;
    double heightScale = deviceSize.height / rect.height;
    double scale = widthScale < heightScale ? widthScale : heightScale;

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
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              // ここで画像表示画面に遷移する
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateImageScreen(
                          path: path,
                          rect: rect,
                        )),
              );
            },
          ),
        ],
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
