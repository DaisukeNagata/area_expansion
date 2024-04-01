import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({
    super.key,
    required this.imageBytes,
    required this.path,
    required this.zoomScale,
  });

  final Uint8List imageBytes;
  final String path;
  final double zoomScale;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  var flg = false;
  void _shareImage() {
    Share.shareFiles([widget.path]);
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
          TextButton(
              onPressed: () {
                setState(() {
                  flg = !flg;
                });
              },
              child: const Text('scale')),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareImage(),
          ),
        ],
      ),
      body: Center(
        child: flg
            ? Image.file(
                File(widget.path),
                filterQuality: FilterQuality.high,
              )
            : Image.memory(
                widget.imageBytes,
                filterQuality: FilterQuality.high,
              ),
      ),
    );
  }
}
